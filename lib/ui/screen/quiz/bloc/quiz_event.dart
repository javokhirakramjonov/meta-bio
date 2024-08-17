part of 'quiz_bloc.dart';

@freezed
class QuizEvent with _$QuizEvent {
  const factory QuizEvent.started() = Started;

  const factory QuizEvent.variantSelected({
    required int questionIndex,
    required Variant variant,
  }) = VariantSelected;

  const factory QuizEvent.variantToggled({
    required int questionIndex,
    required Variant variant,
  }) = VariantToggled;

  const factory QuizEvent.submit() = Submit;
}
