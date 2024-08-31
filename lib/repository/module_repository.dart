import 'package:dio/dio.dart';
import 'package:meta_bio/domain/module.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/dio_provider.dart';

class ModuleRepository {
  late Dio _dio;

  ModuleRepository(DioProvider dioProvider) {
    _dio = dioProvider.dio;
  }

  Future<RequestState<List<Module>>> getModules() async {
    try {
      final response = await _dio.get('/api/modules');

      final List<Module> modules = (response.data['data'] as List)
          .map((e) => Module.fromJson(e))
          .toList();

      return RequestState.success(modules);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
