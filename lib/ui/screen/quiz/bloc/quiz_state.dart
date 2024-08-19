part of 'quiz_bloc.dart';

@freezed
class QuizState with _$QuizState {
  const factory QuizState.initial({
    required int examId,
    @Default({}) Map<int, Set<int>> selectedVariantIds,
    @Default(RequestStateInitial()) RequestState<void> submitRequestState,
    @Default(RequestStateInitial())
    RequestState<void> loadQuestionsRequestState,
    @Default([]) List<Question> questions,
    @Default(RequestStateInitial()) readyToStartRequestState,
    @Default('00:00') String time,
  }) = _Initial;

  const QuizState._();

  bool get isLoading =>
      loadQuestionsRequestState is RequestStateLoading ||
      readyToStartRequestState is RequestStateLoading ||
      submitRequestState is RequestStateLoading;
}
