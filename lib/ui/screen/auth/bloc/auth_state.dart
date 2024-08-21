part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.state({
    @Default("") String phoneNumber,
    @Default("") String password,
    @Default(false) bool isPasswordVisible,
    @Default(RequestState.initial()) RequestState loginRequestState,
  }) = _AuthState;
}
