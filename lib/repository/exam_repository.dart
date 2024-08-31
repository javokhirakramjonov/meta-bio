import 'package:dio/dio.dart';
import 'package:meta_bio/domain/answer.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/domain/user.dart';
import 'package:meta_bio/service/dio_provider.dart';
import 'package:meta_bio/util/global.dart';

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
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<RequestState<ExamResult>> submit(
      int examId, List<Answer> answers) async {
    try {
      // final response = await _dio.post(
      //   '/api/exams/$examId/submit',
      //   data: {'answers': answers.map((e) => e.toJson()).toList()},
      // );
      //
      // final examResult = ExamResult.fromJson(response.data['json']);

      final examResult = ExamResult(
        user: User(
          avatar: '',
          firstName: '',
          lastName: '',
          score: 100,
        ),
        correctCount: 10,
        inCorrectCount: 10,
        duration: '10:10',
        score: 20,
      );

      globalProfileObservable.value = globalProfileObservable.value?.copyWith(
        score: examResult.user.score,
      );

      return RequestState.success(examResult);
    } on DioException catch (e) {
      return RequestState.error(e.error.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
