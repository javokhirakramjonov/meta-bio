import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/api_service.dart';
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

      _loadProfile();

      if (isLoggedIn) {
        return const RequestState.success();
      } else {
        return const RequestState.error(
            'Phone number or password is incorrect');
      }
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<void> _loadProfile() async {
    final response = await _dio.get('/api/users/profile');
    var profile = Profile.fromJson(response.data['data']);

    var avatarFile = await downloadImage(profile.avatar, profile.avatar);

    profile = profile.copyWith(avatar: avatarFile.path);

    await _sharedPreferences.setString('profile', jsonEncode(profile));
  }

  Future<RequestState<void>> updateProfile(Profile profile) async {
    try {
      final response = await _dio.put(
        '/api/users/${profile.id}',
        data: profile.toJson(),
      );

      if (response.statusCode == 200) {
        await _sharedPreferences.setString('profile', jsonEncode(profile));
        return const RequestState.success();
      } else {
        return const RequestState.error('Failed to update profile');
      }
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<File> downloadImage(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    final filePath = '${directory.path}/images/$fileName';

    Dio dio = Dio();
    await dio.download(url, filePath);

    return File(filePath);
  }
}
