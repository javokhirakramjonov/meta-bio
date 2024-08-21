part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.state() = _SplashState;

  const factory SplashState.openScreen({required Widget nextScreen}) =
      SplashOpenNextScreen;
}
