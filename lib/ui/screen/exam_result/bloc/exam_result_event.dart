part of 'exam_result_bloc.dart';

@freezed
class ExamResultEvent with _$ExamResultEvent {
  const factory ExamResultEvent.loadAllStudentsExamResults() =
      LoadAllStudentsExamResults;
}
