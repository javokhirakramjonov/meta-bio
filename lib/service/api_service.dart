import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://46.101.218.225';

  late Dio _dio;
  late FlutterSecureStorage _secureStorage;

  ApiService(FlutterSecureStorage secureStorage) {
    _secureStorage = secureStorage;

    _dio = Dio(BaseOptions(baseUrl: baseUrl));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onError: _onError,
    ));
  }

  void _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path == '/api/auth/login') return handler.next(options);

    options.headers['Authorization'] =
        'Bearer ${await _secureStorage.read(key: 'token')}';

    handler.next(options);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    handler.next(error);
  }

  Dio get dio => _dio;
}
