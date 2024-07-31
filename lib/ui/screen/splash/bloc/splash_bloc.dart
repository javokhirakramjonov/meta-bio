import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_event.dart';

part 'splash_state.dart';

part 'splash_bloc.freezed.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState.initial()) {
    on<SplashStarted>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2), () {
        emit(const SplashState.openDashboardScreen());
      });
    });
  }
}
