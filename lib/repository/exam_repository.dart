import 'package:dio/dio.dart';
import 'package:meta_bio/domain/answer.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/domain/exam_leader.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/domain/exam_result_review_item.dart';
import 'package:meta_bio/domain/question.dart';
import 'package:meta_bio/domain/request_state.dart';
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
      final response = await _dio.post(
        '/api/exams/$examId/submit',
        data: {'answers': answers.map((e) => e.toJson()).toList()},
      );

      final examResult = ExamResult.fromJson(response.data['data']);

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

  Future<RequestState<List<ExamLeader>>> getAllStudentsExamResults(
      int examId) async {
    try {
      final response = await _dio.get('/api/exams/$examId/results');

      final List<ExamLeader> examResults = (response.data['data'] as List)
          .map((e) => ExamLeader.fromJson(e))
          .toList();

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

  Future<RequestState<List<ExamResultReviewItem>>> getExamResultReviewItems(
      int resultId) async {
    try {
      final response = await _dio.get('/api/results/$resultId/review');

      final examResultReviewItems = (response.data['data'] as List)
          .map((e) => ExamResultReviewItem.fromJson(e))
          .toList();

      // final examResultReviewItems = List.generate(10, (index) {
      //   return ExamResultReviewItem(
      //     question: Question(
      //         id: index,
      //         text: 'Question $index',
      //         variants: List.generate(4, (index) {
      //           return Variant(
      //             id: index,
      //             text: 'Option $index',
      //           );
      //         }),
      //         mark: 1,
      //         type: QuestionType.singleChoice,
      //         rank: index),
      //     selectedVariantIds: {index % 4},
      //     correctVariantIds: {1},
      //   );
      // });

      return RequestState.success(examResultReviewItems);
    } on DioException catch (e) {
      return RequestState.error(e.message.toString());
    } catch (e) {
      return RequestState.error(e.toString());
    }
  }
}
