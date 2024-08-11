part of 'update_password_bloc.dart';

@freezed
class UpdatePasswordState with _$UpdatePasswordState {
  const factory UpdatePasswordState.initial({
    @Default('') String oldPassword,
    @Default('') String newPassword,
    @Default(false) bool isOldPasswordVisible,
    @Default(false) bool isNewPasswordVisible,
  }) = _Initial;
}
