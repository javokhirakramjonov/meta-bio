import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/exam_repository.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'exams_bloc.freezed.dart';
part 'exams_event.dart';
part 'exams_state.dart';

class ExamsBloc extends RequestStateHandlerBloc<ExamsEvent, ExamsState> {
  final ExamRepository _examRepository;

  ExamsBloc(this._examRepository, context)
      : super(const ExamsState.initial(), context) {
    on<Started>(_started);
  }

  void _started(Started event, Emitter<ExamsState> emit) async {
    emit(state.copyWith(examsRequestState: const RequestState.loading()));

    await Future.delayed(const Duration(milliseconds: 200));

    final examsRequestState = await _examRepository.getExams(event.moduleId);

    super.handleRequestState(examsRequestState);

    emit(state.copyWith(examsRequestState: examsRequestState));
  }
}
