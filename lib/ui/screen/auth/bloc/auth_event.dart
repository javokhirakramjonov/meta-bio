part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginClicked() = AuthLoginClicked;
  const factory AuthEvent.toggledPasswordVisibility({required bool isPasswordVisible}) = AuthToggledPasswordVisibility;
  const factory AuthEvent.phoneNumberChanged({required String newPhoneNumber}) = AuthPhoneNumberChanged;
  const factory AuthEvent.passwordChanged({required String newPassword}) = AuthPasswordChanged;
}
