import 'package:dio/dio.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/api_service.dart';

class ExamRepository {
  late Dio _dio;

  ExamRepository(ApiService apiService) {
    _dio = apiService.dio;
  }

  Future<RequestState<List<Exam>>> getExams(int moduleId) async {
    try {
      final response = await _dio.get('/api/exams', queryParameters: {
        'moduleId': moduleId,
      });

      final List<Exam> exams =
          (response.data['data'] as List).map((e) => Exam.fromJson(e)).toList();

      return RequestState.success(exams);
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
