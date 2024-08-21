import 'package:dio/dio.dart';
import 'package:meta_bio/domain/answer.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/dio_provider.dart';

class ExamRepository {
  late Dio _dio;

  ExamRepository(DioProvider dioProvider) {
    _dio = dioProvider.dio;
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

  Future<RequestState<void>> submit(int examId, List<Answer> answers) async {
    try {
      await _dio.post(
        '/api/exams/$examId/submit',
        data: {'answers': answers.map((e) => e.toJson()).toList()},
      );
      return const RequestState.success(null);
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
