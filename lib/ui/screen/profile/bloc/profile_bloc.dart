import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/auth_repository.dart';
import 'package:meta_bio/util/global.dart';
import 'package:meta_bio/util/observer.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends RequestStateHandlerBloc<ProfileEvent, ProfileState>
    implements Observer<Profile?> {
  final AuthRepository _authRepository;
  final ImagePicker _picker = ImagePicker();

  ProfileBloc(this._authRepository, context)
      : super(const ProfileState.state(), context) {
    on<Started>(_started);
    on<FirstNameChanged>(_firstNameChanged);
    on<LastNameChanged>(_lastNameChanged);
    on<PickAvatar>(_pickAvatar);
    on<UpdateProfile>(_updateProfile);
    on<ProfileLoadedFromGlobal>(_profileLoadedFromGlobal);
    on<Logout>(_logout);
  }

  void _started(Started event, Emitter<ProfileState> emit) async {
    globalProfileObservable.addListener(this);
  }

  void _firstNameChanged(
      FirstNameChanged event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
        profile: state.profile?.copyWith(firstName: event.firstName)));
  }

  void _lastNameChanged(
      LastNameChanged event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
        profile: state.profile?.copyWith(lastName: event.lastName)));
  }

  void _updateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
        updateProfileRequestState: const RequestState.loading()));

    final response = await _authRepository.updateProfile(state.profile!);

    super.handleRequestState(response, successMessage: 'Profile updated');

    emit(state.copyWith(updateProfileRequestState: response));
  }

  void _pickAvatar(PickAvatar event, Emitter<ProfileState> emit) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    emit(
        state.copyWith(updateAvatarRequestState: const RequestState.loading()));

    final response = await _authRepository.updateAvatar(image.path);

    super.handleRequestState(response, successMessage: 'Avatar updated');

    emit(state.copyWith(updateAvatarRequestState: response));
  }

  void _logout(Logout event, Emitter<ProfileState> emit) async {
    await _authRepository.logout();

    emit(state.copyWith(shouldLogOut: true));
  }

  @override
  void notify(Profile? profile) {
    add(ProfileLoadedFromGlobal(profile));
  }

  void _profileLoadedFromGlobal(
      ProfileLoadedFromGlobal event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(profile: event.profile));
  }

  @override
  Future<void> close() async {
    globalProfileObservable.removeListener(this);
    super.close();
  }
}
