import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'exam_result_bloc.freezed.dart';
part 'exam_result_event.dart';
part 'exam_result_state.dart';

class ExamResultBloc
    extends RequestStateErrorHandlerBloc<ExamResultEvent, ExamResultState> {
  ExamResultBloc(examResult, context)
      : super(ExamResultState.state(examResult: examResult), context) {
    on<LoadAllStudentsExamResults>(_loadAllStudentsExamResults);
  }

  void _loadAllStudentsExamResults(
      LoadAllStudentsExamResults event, Emitter<ExamResultState> emit) {}
}
