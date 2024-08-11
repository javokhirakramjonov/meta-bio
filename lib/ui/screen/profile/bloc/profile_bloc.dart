import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;

  ProfileBloc(this._authRepository, this._sharedPreferences)
      : super(const ProfileState.initial()) {
    on<Started>(_started);
    on<FirstNameChanged>(_firstNameChanged);
    on<LastNameChanged>(_lastNameChanged);
    on<UpdateProfile>(_updateProfile);
  }

  void _started(Started event, Emitter<ProfileState> emit) async {
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

    emit(state.copyWith(updateProfileRequestState: response));
  }
}
