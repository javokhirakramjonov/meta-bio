part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial({
    Profile? profile,
    @Default(RequestStateInitial())
    RequestState<void> updateProfileRequestState,
    @Default(RequestStateInitial())
    RequestState<String> updateAvatarRequestState,
    @Default(false) bool shouldLogOut,
    @Default(RequestStateInitial())
    RequestState<Profile> loadProfileRequestState,
  }) = _Initial;

  const ProfileState._();

  bool get isLoading =>
      profile == null ||
      updateProfileRequestState is RequestStateLoading ||
      updateAvatarRequestState is RequestStateLoading ||
      loadProfileRequestState is RequestStateLoading;
}
