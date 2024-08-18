import 'package:dio/dio.dart';
import 'package:meta_bio/domain/answer.dart';
import 'package:meta_bio/domain/question.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/service/api_service.dart';

class QuizRepository {
  late Dio _dio;

  QuizRepository(ApiService apiService) {
    _dio = apiService.dio;
  }

  Future<RequestState<List<Question>>> getQuestions(int examId) async {
    try {
      final response = await _dio.get('/api/exams/$examId/questions');

      final List<Question> modules = (response.data['data'] as List)
          .map((e) => Question.fromJson(e))
          .toList();

      return RequestState.success(modules);
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<RequestState<void>> readyToStart(int examId) async {
    try {
      await _dio.post('/api/exams/$examId/start');

      return const RequestState.success(null);
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
