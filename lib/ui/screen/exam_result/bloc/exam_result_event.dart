part of 'exam_result_bloc.dart';

@freezed
class ExamResultEvent with _$ExamResultEvent {
  const factory ExamResultEvent.started() = Started;

  const factory ExamResultEvent.loadAllStudentsExamResults() =
      LoadAllStudentsExamResults;

  const factory ExamResultEvent.profileLoadedFromGlobal(Profile? profile) =
      ProfileLoadedFromGlobal;
}
