import 'package:dio/dio.dart';
import 'package:meta_bio/domain/answer.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/domain/question.dart';
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
          firstName: 'Student',
          lastName: 'Surname',
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

  Future<RequestState<List<ExamResult>>> getAllStudentsExamResults(
      int examId) async {
    try {
      // final response = await _dio.get('/api/exams/$examId/results');

      // final List<ExamResult> examResults = (response.data['data'] as List)
      //     .map((e) => ExamResult.fromJson(e))
      //     .toList();

      // TODO: Remove fake part
      List<ExamResult> examResults = List.generate(50, (index) {
        return ExamResult(
          user: User(
            avatar: '',
            firstName: 'Student ${index + 1}',
            lastName: 'Surname ${index + 1}',
            score: 100,
            rank: index + 1,
          ),
          correctCount: 10,
          inCorrectCount: 10,
          duration: '10:10',
          score: 20,
        );
      });

      return RequestState.success(examResults);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<RequestState<List<Question>>> getQuestions(int examId) async {
    try {
      final response = await _dio.get('/api/exams/$examId/questions');

      final List<Question> modules = (response.data['data'] as List)
          .map((e) => Question.fromJson(e))
          .toList();

      return RequestState.success(modules);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }

  Future<RequestState<void>> readyToStart(int examId) async {
    try {
      await _dio.post('/api/exams/$examId/start');

      return const RequestState.success(null);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
