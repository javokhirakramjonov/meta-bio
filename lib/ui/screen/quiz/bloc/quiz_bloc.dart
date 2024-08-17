import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/answer.dart';
import 'package:meta_bio/domain/question.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/domain/variant.dart';
import 'package:meta_bio/repository/quiz_repository.dart';

part 'quiz_bloc.freezed.dart';
part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _quizRepository;

  QuizBloc(this._quizRepository, int examId)
      : super(QuizState.initial(examId: examId)) {
    on<Started>(_onStarted);
    on<VariantSelected>(_onVariantSelected);
    on<VariantToggled>(_onVariantToggled);
    on<Submit>(_onSubmit);
  }

  void _onStarted(Started event, Emitter<QuizState> emit) async {
    await _loadQuestions(emit);
  }

  Future<void> _loadQuestions(Emitter<QuizState> emit) async {
    emit(state.copyWith(
      loadQuestionsRequestState: const RequestStateLoading(),
    ));

    final questionsRequestState =
        await _quizRepository.getQuestions(state.examId);

    var questions = <Question>[];
    var selectedVariants = <Set<Variant>>[];

    if (questionsRequestState is RequestStateSuccess<List<Question>>) {
      questions = questionsRequestState.data;
      selectedVariants = List.generate(questions.length, (_) => {});

      _notifyReadyToStart(emit);
    }

    emit(state.copyWith(
      loadQuestionsRequestState: questionsRequestState,
      questions: questions,
      selectedVariants: selectedVariants,
    ));
  }

  void _notifyReadyToStart(Emitter<QuizState> emit) async {
    emit(state.copyWith(
      readyToStartRequestState: const RequestStateLoading(),
    ));

    final readyToStartRequestState =
        await _quizRepository.readyToStart(state.examId);

    emit(state.copyWith(
      readyToStartRequestState: readyToStartRequestState,
    ));
  }

  void _onVariantSelected(
      VariantSelected event, Emitter<QuizState> emit) async {
    final selectedVariants = List.of(state.selectedVariants);

    selectedVariants[event.questionIndex] = {event.variant};

    emit(state.copyWith(selectedVariants: selectedVariants));
  }

  void _onVariantToggled(VariantToggled event, Emitter<QuizState> emit) async {
    final selectedVariants = List.of(state.selectedVariants);

    if (selectedVariants[event.questionIndex].contains(event.variant)) {
      selectedVariants[event.questionIndex].remove(event.variant);
    } else {
      selectedVariants[event.questionIndex].add(event.variant);
    }

    emit(state.copyWith(selectedVariants: selectedVariants));
  }

  void _onSubmit(Submit event, Emitter<QuizState> emit) async {
    emit(state.copyWith(submitRequestState: const RequestStateLoading()));

    final selectedVariants = state.selectedVariants;
    final questions = state.questions;

    final answers = List.generate(questions.length, (index) {
      final question = questions[index];
      final selectedVariantIds =
          selectedVariants[index].map((e) => e.id).toList();

      return Answer(
        questionId: question.id,
        variantIds: selectedVariantIds,
      );
    });

    final submitRequestState =
        await _quizRepository.submit(state.examId, answers);

    emit(state.copyWith(submitRequestState: submitRequestState));
  }
}
