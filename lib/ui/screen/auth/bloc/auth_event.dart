part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginClicked() = LoginClicked;

  const factory AuthEvent.toggledPasswordVisibility(
      {required bool isPasswordVisible}) = ToggledPasswordVisibility;

  const factory AuthEvent.phoneNumberChanged({required String newPhoneNumber}) =
      PhoneNumberChanged;

  const factory AuthEvent.passwordChanged({required String newPassword}) =
      PasswordChanged;
}
