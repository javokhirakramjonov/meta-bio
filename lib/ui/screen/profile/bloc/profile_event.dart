part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = Started;

  const factory ProfileEvent.firstNameChanged(String firstName) =
      FirstNameChanged;

  const factory ProfileEvent.lastNameChanged(String lastName) = LastNameChanged;

  const factory ProfileEvent.updateProfile() = UpdateProfile;

  const factory ProfileEvent.pickAvatar() = PickAvatar;

  const factory ProfileEvent.logout() = Logout;
}
