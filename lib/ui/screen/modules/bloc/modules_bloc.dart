import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/module.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/module_repository.dart';
import 'package:meta_bio/util/global.dart';
import 'package:meta_bio/util/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'modules_bloc.freezed.dart';
part 'modules_event.dart';
part 'modules_state.dart';

class ModulesBloc extends Bloc<ModulesEvent, ModulesState>
    implements Observer<Profile?> {
  final SharedPreferences _sharedPreferences;
  final ModuleRepository _moduleRepository;

  ModulesBloc(this._sharedPreferences, this._moduleRepository)
      : super(const ModulesState.initial()) {
    on<Started>(_started);
    on<ProfileUpdated>(_profileUpdated);
    on<LoadModules>(_loadModules);
  }

  void _started(Started event, Emitter<ModulesState> emit) async {
    globalProfileObservable.addListener(this);
    add(const ModulesEvent.loadModules());
    _loadProfile(emit);
  }

  void _profileUpdated(ProfileUpdated event, Emitter<ModulesState> emit) async {
    emit(state.copyWith(profile: event.profile));
  }

  void _loadProfile(Emitter<ModulesState> emit) async {
    final profileJson = _sharedPreferences.getString('profile');

    if (profileJson == null) {
      return;
    }

    final profile = Profile.fromJson(jsonDecode(profileJson));

    emit(state.copyWith(profile: profile));
  }

  Future<void> _loadModules(
      LoadModules event, Emitter<ModulesState> emit) async {
    emit(state.copyWith(modulesRequestState: const RequestState.loading()));

    await Future.delayed(const Duration(seconds: 1));

    final modulesRequestState = await _moduleRepository.getModules();

    emit(state.copyWith(modulesRequestState: modulesRequestState));
  }

  @override
  void notify(Profile? profile) {
    if (profile == null) {
      return;
    }
    add(ProfileUpdated(profile));
  }
}
