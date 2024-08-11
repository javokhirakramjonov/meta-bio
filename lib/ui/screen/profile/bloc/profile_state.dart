part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial({
    Profile? profile,
    @Default(RequestState.initial())
    RequestState<void> updateProfileRequestState,
  }) = _Initial;

  const ProfileState._();

  bool get isLoading =>
      profile == null ||
      updateProfileRequestState == const RequestState.loading();
}
