import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/dio_provider.dart';
import 'package:meta_bio/util/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  AuthRepository(
      DioProvider dioProvider, this._secureStorage, this._sharedPreferences) {
    _dio = dioProvider.dio;
  }

  Future<RequestState> login(String phoneNumber, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      await _secureStorage.write(
          key: 'token', value: response.data['accessToken']);
      await _secureStorage.write(key: 'password', value: password);

      final loadProfileRequestState = await _loadProfile();

      if (loadProfileRequestState is RequestStateError) {
        return loadProfileRequestState;
      }

      return const RequestState.success(null);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<RequestState<Profile>> _loadProfile() async {
    try {
      final response = await _dio.get('/api/users/profile');
      var profile = Profile.fromJson(response.data['data']);

      await _saveProfile(profile);

      return RequestStateSuccess(profile);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<void> _saveProfile(Profile profile,
      {bool shouldDownloadImage = true}) async {
    if (shouldDownloadImage) {
      DateTime now = DateTime.now();

      final avatarFileName =
          "${now.toString()}.${profile.avatar.split('.').last}";

      var avatarFile = await _downloadImage(profile.avatar, avatarFileName);

      profile = profile.copyWith(avatar: avatarFile.path);
    }

    await _sharedPreferences.setString('profile', jsonEncode(profile));

    globalProfileObservable.value = profile;
  }

  Future<RequestState> updateProfile(Profile profileToUpdate) async {
    try {
      final response = await _dio.put(
        '/api/users/${profileToUpdate.id}',
        data: profileToUpdate.toJson(),
      );

      final profile = Profile.fromJson(response.data['data']);

      await _saveProfile(profile.copyWith(avatar: profileToUpdate.avatar),
          shouldDownloadImage: false);

      return const RequestState.success(null);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<File> _downloadImage(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    final filePath = '${directory.path}/images/$fileName';

    await _dio.download(url, filePath);

    return File(filePath);
  }

  Future<RequestState> updatePassword(String newPassword) async {
    try {
      final profileJson = _sharedPreferences.getString('profile');
      final profile = Profile.fromJson(jsonDecode(profileJson!));

      final oldPassword = await _secureStorage.read(key: 'password');

      await _dio.put(
        '/api/users/change-password',
        data: {
          'phoneNumber': profile.phoneNumber,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      await _secureStorage.write(key: 'password', value: newPassword);

      return const RequestState.success(null);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<RequestState> updateAvatar(String avatarPath) async {
    try {
      await _dio.put(
        '/api/users/upload-avatar',
        data: FormData.fromMap({
          "avatarFile": await MultipartFile.fromFile(avatarPath,
              filename: avatarPath.split('/').last),
        }),
      );

      final loadProfileRequestState = await _loadProfile();

      if (loadProfileRequestState is RequestStateError) {
        return loadProfileRequestState;
      }

      return const RequestState.success(null);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<void> logout() async {
    await Future.wait([
      _secureStorage.deleteAll(),
      _sharedPreferences.clear(),
    ]);
  }
}
