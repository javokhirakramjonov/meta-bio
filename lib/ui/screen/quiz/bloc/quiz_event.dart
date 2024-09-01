part of 'quiz_bloc.dart';

@freezed
class QuizEvent with _$QuizEvent {
  const factory QuizEvent.started() = Started;

  const factory QuizEvent.timerTicked(String time) = TimerTicked;

  const factory QuizEvent.variantSelected({
    required int questionId,
    required int variantId,
    required QuestionType questionType,
  }) = VariantSelected;

  const factory QuizEvent.submit() = Submit;
}
