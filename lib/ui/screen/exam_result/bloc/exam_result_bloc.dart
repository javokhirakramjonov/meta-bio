import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/exam_repository.dart';
import 'package:meta_bio/util/global.dart';
import 'package:meta_bio/util/observer.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'exam_result_bloc.freezed.dart';
part 'exam_result_event.dart';
part 'exam_result_state.dart';

class ExamResultBloc
    extends RequestStateErrorHandlerBloc<ExamResultEvent, ExamResultState>
    implements Observer<Profile?> {
  final int _examId;
  final ExamRepository _examRepository;

  ExamResultBloc(this._examRepository, this._examId, examResult, context)
      : super(ExamResultState.state(examResult: examResult), context) {
    on<LoadAllStudentsExamResults>(_loadAllStudentsExamResults);
    on<ProfileLoadedFromGlobal>(_profileUpdated);
    on<Started>(_started);
  }

  void _loadAllStudentsExamResults(
      LoadAllStudentsExamResults event, Emitter<ExamResultState> emit) async {
    emit(state.copyWith(
        allStudentsExamResultRequestState: const RequestState.loading()));

    final response = await _examRepository.getAllStudentsExamResults(_examId);

    super.handleRequestStateError(response);

    emit(state.copyWith(allStudentsExamResultRequestState: response));
  }

  void _profileUpdated(
      ProfileLoadedFromGlobal event, Emitter<ExamResultState> emit) async {
    emit(state.copyWith(profile: event.profile));
  }

  void _started(Started event, Emitter<ExamResultState> emit) async {
    add(const LoadAllStudentsExamResults());
    globalProfileObservable.addListener(this);
  }

  @override
  void notify(Profile? value) async {
    add(ProfileLoadedFromGlobal(value));
  }

  @override
  Future<void> close() {
    globalProfileObservable.removeListener(this);
    return super.close();
  }
}
