part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial({
    @Default("") String phoneNumber,
    @Default("") String password,
    @Default(false) bool isPasswordVisible,
    @Default(RequestState.initial()) RequestState<void> loginRequestState,
  }) = _Initial;
}
