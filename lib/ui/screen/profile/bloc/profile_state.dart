part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial(
      {Profile? profile,
      @Default(RequestState.initial())
      RequestState<void> updateProfileRequestState,
      @Default(RequestState.initial())
      RequestState<String> updateAvatarRequestState,
      @Default(false) bool shouldLogOut}) = _Initial;

  const ProfileState._();

  bool get isLoading =>
      profile == null || updateProfileRequestState is RequestStateLoading;
}
