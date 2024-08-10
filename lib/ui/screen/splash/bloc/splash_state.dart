part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = SplashInitial;
  const factory SplashState.openScreen({required Widget nextScreen}) = SplashOpenNextScreen;
}
