part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.state(
      {Profile? profile,
      @Default(RequestStateInitial()) RequestState updateProfileRequestState,
      @Default(RequestStateInitial()) RequestState updateAvatarRequestState,
      @Default(false) bool shouldLogOut}) = _ProfileState;

  const ProfileState._();

  bool get isLoading => profile == null;
}
