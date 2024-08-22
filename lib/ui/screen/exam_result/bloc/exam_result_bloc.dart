import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/util/observer.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'exam_result_bloc.freezed.dart';
part 'exam_result_event.dart';
part 'exam_result_state.dart';

class ExamResultBloc
    extends RequestStateErrorHandlerBloc<ExamResultEvent, ExamResultState>
    implements Observer<Profile?> {
  ExamResultBloc(examResult, context)
      : super(ExamResultState.state(examResult: examResult), context) {
    on<LoadAllStudentsExamResults>(_loadAllStudentsExamResults);
    on<ProfileLoadedFromGlobal>(_profileUpdated);
  }

  void _loadAllStudentsExamResults(
      LoadAllStudentsExamResults event, Emitter<ExamResultState> emit) {}

  void _profileUpdated(
      ProfileLoadedFromGlobal event, Emitter<ExamResultState> emit) {
    emit(state.copyWith(profile: event.profile));
  }

  @override
  void notify(Profile? value) {
    add(ProfileLoadedFromGlobal(value));
  }
}
