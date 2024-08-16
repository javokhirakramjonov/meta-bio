import 'package:dio/dio.dart';
import 'package:meta_bio/domain/module.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/api_service.dart';

class ModuleRepository {
  late Dio _dio;

  ModuleRepository(ApiService apiService) {
    _dio = apiService.dio;
  }

  Future<RequestState<List<Module>>> getModules() async {
    try {
      final response = await _dio.get('/api/modules');

      final List<Module> modules = (response.data['data'] as List)
          .map((e) => Module.fromJson(e))
          .toList();

      return RequestState.success(modules);
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
