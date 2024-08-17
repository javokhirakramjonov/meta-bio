part of 'exams_bloc.dart';

@freezed
class ExamsState with _$ExamsState {
  const factory ExamsState.initial(
      {@Default(RequestStateInitial())
      RequestState<List<Exam>> examsRequestState}) = _Initial;
}
