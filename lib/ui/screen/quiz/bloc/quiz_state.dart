part of 'quiz_bloc.dart';

@freezed
class QuizState with _$QuizState {
  const factory QuizState.initial({
    required int examId,
    @Default(-1) int currentQuestionIndex,
    @Default([]) List<Set<Variant>> selectedVariants,
    @Default(RequestStateInitial()) RequestState<void> submitRequestState,
    @Default(RequestStateInitial())
    RequestState<void> loadQuestionsRequestState,
    @Default([]) List<Question> questions,
    @Default(RequestStateInitial()) readyToStartRequestState,
  }) = _Initial;
}
