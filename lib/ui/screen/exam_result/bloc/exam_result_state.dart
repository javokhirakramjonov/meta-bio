part of 'exam_result_bloc.dart';

@freezed
class ExamResultState with _$ExamResultState {
  const factory ExamResultState.state({
    required ExamResult examResult,
    @Default(RequestStateInitial())
    RequestState<List<ExamLeader>> allStudentsExamResultRequestState,
    Profile? profile,
  }) = _ExamResultState;
}
