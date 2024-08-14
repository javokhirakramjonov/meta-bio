part of 'update_password_bloc.dart';

@freezed
class UpdatePasswordEvent with _$UpdatePasswordEvent {
  const factory UpdatePasswordEvent.oldPasswordChanged(String oldPassword) =
      OldPasswordChanged;

  const factory UpdatePasswordEvent.newPasswordChanged(String newPassword) =
      NewPasswordChanged;

  const factory UpdatePasswordEvent.updatePassword() = UpdatePassword;

  const factory UpdatePasswordEvent.toggleOldPasswordVisibility(
      bool newVisibility) = ToggleOldPasswordVisibility;

  const factory UpdatePasswordEvent.toggleNewPasswordVisibility(
      bool newVisibility) = ToggleNewPasswordVisibility;

  const factory UpdatePasswordEvent.validateOldPassword() = ValidateOldPassword;
}
