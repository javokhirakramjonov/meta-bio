import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exams_event.dart';
part 'exams_state.dart';
part 'exams_bloc.freezed.dart';

class ExamsBloc extends Bloc<ExamsEvent, ExamsState> {
  ExamsBloc() : super(const ExamsState.initial()) {
    on<ExamsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
