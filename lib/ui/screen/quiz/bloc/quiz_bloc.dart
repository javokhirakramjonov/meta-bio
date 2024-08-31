import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/answer.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/domain/question.dart';
import 'package:meta_bio/domain/question_type.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/exam_repository.dart';
import 'package:meta_bio/repository/quiz_repository.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'quiz_bloc.freezed.dart';
part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends RequestStateErrorHandlerBloc<QuizEvent, QuizState> {
  final QuizRepository _quizRepository;
  final ExamRepository _examRepository;

  QuizBloc(this._quizRepository, this._examRepository, int examId, context)
      : super(QuizState.initial(examId: examId), context) {
    on<Started>(_onStarted);
    on<VariantSelected>(_onVariantSelected);
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

    super.handleRequestStateError(questionsRequestState);

    var questions = <Question>[];
    Map<int, Set<int>> selectedVariantIds = {};

    if (questionsRequestState is RequestStateSuccess<List<Question>>) {
      questions = questionsRequestState.data;
      selectedVariantIds = {};

      await _notifyReadyToStart(emit);
    }

    emit(state.copyWith(
      loadQuestionsRequestState: questionsRequestState,
      questions: questions,
      selectedVariantIds: selectedVariantIds,
    ));
  }

  Future<void> _notifyReadyToStart(Emitter<QuizState> emit) async {
    emit(state.copyWith(
      readyToStartRequestState: const RequestStateLoading(),
    ));

    final readyToStartRequestState =
        await _quizRepository.readyToStart(state.examId);

    super.handleRequestStateError(readyToStartRequestState);

    emit(state.copyWith(
      readyToStartRequestState: readyToStartRequestState,
    ));
  }

  void _onVariantSelected(
      VariantSelected event, Emitter<QuizState> emit) async {
    final selectedVariantIds =
        Map<int, Set<int>>.from(state.selectedVariantIds);

    var selectedVariantIdsOfQuestion =
        selectedVariantIds[event.questionId] ?? <int>{};

    selectedVariantIdsOfQuestion = Set.from(selectedVariantIdsOfQuestion);

    if (event.questionType == QuestionType.singleChoice) {
      selectedVariantIdsOfQuestion = {event.variantId};
    } else if (event.questionType == QuestionType.multipleChoice) {
      if (selectedVariantIdsOfQuestion.contains(event.variantId)) {
        selectedVariantIdsOfQuestion.remove(event.variantId);
      } else {
        selectedVariantIdsOfQuestion.add(event.variantId);
      }
    }

    selectedVariantIds[event.questionId] = selectedVariantIdsOfQuestion;

    emit(state.copyWith(selectedVariantIds: selectedVariantIds));
  }

  void _onSubmit(Submit event, Emitter<QuizState> emit) async {
    emit(state.copyWith(submitRequestState: const RequestStateLoading()));

    final questions = state.questions;

    final answers = List.generate(questions.length, (index) {
      final question = questions[index];
      final selectedVariantIds = state.selectedVariantIds[question.id] ?? {};

      return Answer(
        questionId: question.id,
        variantIds: selectedVariantIds.toList(),
      );
    });

    final submitRequestState =
        await _examRepository.submit(state.examId, answers);

    super.handleRequestStateError(submitRequestState);

    emit(state.copyWith(submitRequestState: submitRequestState));
  }
}
