import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/api_service.dart';

class AuthRepository {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthRepository(ApiService apiService, this._secureStorage) {
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

      if (isLoggedIn) {
        await _secureStorage.write(
            key: 'token', value: response.data['accessToken']);
      }

      if(isLoggedIn) {
        return const RequestState.success();
      } else {
        return const RequestState.error('Phone number or password is incorrect');
      }
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
