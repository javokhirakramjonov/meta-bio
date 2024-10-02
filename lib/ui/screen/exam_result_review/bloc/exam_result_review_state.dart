part of 'exam_result_review_bloc.dart';

@freezed
class ExamResultReviewState with _$ExamResultReviewState {
  const factory ExamResultReviewState.state(
      {@Default(RequestStateInitial())
      RequestState<List<ExamResultReviewItem>>
          examResultReviewItemsState}) = _State;
}
