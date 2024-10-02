import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/exam_result_review_item.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/exam_repository.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'exam_result_review_bloc.freezed.dart';
part 'exam_result_review_event.dart';
part 'exam_result_review_state.dart';

class ExamResultReviewBloc extends RequestStateHandlerBloc<
    ExamResultReviewEvent, ExamResultReviewState> {
  final ExamRepository _examRepository;

  ExamResultReviewBloc(this._examRepository, context)
      : super(const ExamResultReviewState.state(), context) {
    on<Started>(_started);
  }

  Future<void> _started(
      Started event, Emitter<ExamResultReviewState> emit) async {
    await loadExamResultReview(event.resultId, emit);
  }

  Future<void> loadExamResultReview(
      int resultId, Emitter<ExamResultReviewState> emit) async {
    emit(state.copyWith(
        examResultReviewItemsState: const RequestStateLoading()));

    await Future.delayed(const Duration(milliseconds: 200));

    final examResultReview =
        await _examRepository.getExamResultReviewItems(resultId);

    handleRequestState(examResultReview,
        defaultErrorMessage: 'Failed to load exam result review');

    emit(state.copyWith(examResultReviewItemsState: examResultReview));
  }
}
