import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/api_service.dart';
import 'package:meta_bio/util/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  AuthRepository(
      ApiService apiService, this._secureStorage, this._sharedPreferences) {
    _dio = apiService.dio;
  }

  Future<RequestState<void>> login(String phoneNumber, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      bool isLoggedIn = response.statusCode == 200;

      if (!isLoggedIn) {
        return const RequestState.error(
            'Phone number or password is incorrect');
      }

      await _secureStorage.write(
          key: 'token', value: response.data['accessToken']);
      await _secureStorage.write(key: 'password', value: password);

      await _loadProfile();

      return const RequestState.success(null);
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<Profile> _loadProfile() async {
    final response = await _dio.get('/api/users/profile');
    var profile = Profile.fromJson(response.data['data']);

    DateTime now = DateTime.now();

    final avatarFileName =
        "${now.toString()}.${profile.avatar.split('.').last}";

    var avatarFile = await _downloadImage(profile.avatar, avatarFileName);

    profile = profile.copyWith(avatar: avatarFile.path);

    await _sharedPreferences.setString('profile', jsonEncode(profile));

    globalProfileObservable.value = profile;

    return profile;
  }

  Future<RequestState<void>> updateProfile(Profile profile) async {
    try {
      final response = await _dio.put(
        '/api/users/${profile.id}',
        data: profile.toJson(),
      );

      if (response.statusCode == 200) {
        await _sharedPreferences.setString('profile', jsonEncode(profile));
        return const RequestState.success(null);
      } else {
        return const RequestState.error('Failed to update profile');
      }
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<File> _downloadImage(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    final filePath = '${directory.path}/images/$fileName';

    Dio dio = Dio();
    await dio.download(url, filePath);

    return File(filePath);
  }

  Future<RequestState<void>> updatePassword(String newPassword) async {
    try {
      final profileJson = _sharedPreferences.getString('profile');
      final profile = Profile.fromJson(jsonDecode(profileJson!));

      final oldPassword = await _secureStorage.read(key: 'password');

      final response = await _dio.put(
        '/api/users/change-password',
        data: {
          'phoneNumber': profile.phoneNumber,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        await _secureStorage.write(key: 'password', value: newPassword);

        return const RequestState.success(null);
      } else {
        return const RequestState.error('Failed to update password');
      }
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<RequestState<String>> updateAvatar(String avatarPath) async {
    try {
      final response = await _dio.put(
        '/api/users/upload-avatar',
        data: FormData.fromMap({
          "avatarFile": await MultipartFile.fromFile(avatarPath,
              filename: avatarPath.split('/').last),
        }),
      );

      if (response.statusCode == 200) {
        final profile = await _loadProfile();

        return RequestState.success(profile.avatar);
      } else {
        return const RequestState.error('Failed to update avatar');
      }
    } catch (e) {
      logger.e(e);
      return RequestState.error(e.toString());
    }
  }
}
