import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta_bio/util/global.dart';

class DioProvider {
  static const String baseUrl = 'http://46.101.218.225';

  late Dio _dio;
  late FlutterSecureStorage _secureStorage;

  DioProvider(FlutterSecureStorage secureStorage) {
    _secureStorage = secureStorage;

    _dio = Dio(BaseOptions(baseUrl: baseUrl));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onError: _onError,
      onResponse: _onResponse,
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
    final path = error.requestOptions.path;
    final errorMessage = error.response?.data['errorMessage'] ??
        error.message ??
        'Something went wrong';

    final errorForLog = 'Path of request: $path\n\nError: $errorMessage';

    logger.e(errorForLog);

    handler.next(error.copyWith(error: errorMessage));
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseMessage =
        'Path of request: ${response.requestOptions.path}\n\nResponse: ${response.data}';

    logger.d(responseMessage);

    handler.next(response);
  }

  Dio get dio => _dio;
}
