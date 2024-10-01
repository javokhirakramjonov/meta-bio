part of 'exam_result_review_bloc.dart';

@freezed
class ExamResultReviewEvent with _$ExamResultReviewEvent {
  const factory ExamResultReviewEvent.started(int examId) = Started;
}
