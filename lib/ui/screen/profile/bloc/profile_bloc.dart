import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/auth_repository.dart';
import 'package:meta_bio/util/global.dart';
import 'package:meta_bio/util/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>
    implements Observer<Profile?> {
  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  final ImagePicker _picker = ImagePicker();

  ProfileBloc(this._authRepository, this._sharedPreferences)
      : super(const ProfileState.initial()) {
    on<Started>(_started);
    on<FirstNameChanged>(_firstNameChanged);
    on<LastNameChanged>(_lastNameChanged);
    on<UpdateProfile>(_updateProfile);
    on<ProfileUpdated>(_profileUpdated);
    on<PickAvatar>(_pickAvatar);
    on<Logout>(_logout);
    on<LoadProfile>(_loadProfile);
  }

  void _started(Started event, Emitter<ProfileState> emit) async {
    globalProfileObservable.addListener(this);

    final profileJson = _sharedPreferences.getString('profile');

    if (profileJson == null) {
      return;
    }

    final profile = Profile.fromJson(jsonDecode(profileJson));

    emit(state.copyWith(profile: profile));
  }

  void _firstNameChanged(
      FirstNameChanged event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
        profile: state.profile?.copyWith(firstName: event.firstName),
        updateProfileRequestState: const RequestState.initial()));
  }

  void _lastNameChanged(
      LastNameChanged event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
        profile: state.profile?.copyWith(lastName: event.lastName),
        updateProfileRequestState: const RequestState.initial()));
  }

  void _updateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
        updateProfileRequestState: const RequestState.loading()));

    final response = await _authRepository.updateProfile(state.profile!);

    emit(state.copyWith(updateProfileRequestState: response));
  }

  void _pickAvatar(PickAvatar event, Emitter<ProfileState> emit) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    emit(
        state.copyWith(updateAvatarRequestState: const RequestState.loading()));

    final response = await _authRepository.updateAvatar(image.path);

    emit(state.copyWith(updateAvatarRequestState: response));
    emit(
        state.copyWith(updateAvatarRequestState: const RequestState.initial()));
  }

  void _logout(Logout event, Emitter<ProfileState> emit) async {
    await _sharedPreferences.clear();
    emit(state.copyWith(shouldLogOut: true));
  }

  @override
  void notify(Profile? profile) {
    if (profile == null) {
      return;
    }
    add(ProfileUpdated(profile));
  }

  void _profileUpdated(ProfileUpdated event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(profile: event.profile));
  }

  void _loadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(loadProfileRequestState: const RequestState.loading()));

    final newProfile = await _authRepository.loadProfile();

    emit(state.copyWith(loadProfileRequestState: newProfile));
    emit(
        state.copyWith(updateAvatarRequestState: const RequestState.initial()));

    if (newProfile is RequestStateSuccess<Profile>) {
      emit(state.copyWith(profile: newProfile.data));
    }
  }

  @override
  Future<void> close() async {
    globalProfileObservable.removeListener(this);
    super.close();
  }
}
