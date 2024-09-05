import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/module.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/module_repository.dart';
import 'package:meta_bio/util/global.dart';
import 'package:meta_bio/util/observer.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'modules_bloc.freezed.dart';
part 'modules_event.dart';
part 'modules_state.dart';

class ModulesBloc extends RequestStateHandlerBloc<ModulesEvent, ModulesState>
    implements Observer<Profile?> {
  final ModuleRepository _moduleRepository;

  ModulesBloc(this._moduleRepository, context)
      : super(const ModulesState.initial(), context) {
    on<Started>(_started);
    on<ProfileLoadedFromGlobal>(_profileUpdated);
    on<LoadModules>(_loadModules);
  }

  void _started(Started event, Emitter<ModulesState> emit) async {
    globalProfileObservable.addListener(this);
    add(const ModulesEvent.loadModules());
  }

  void _profileUpdated(
      ProfileLoadedFromGlobal event, Emitter<ModulesState> emit) async {
    emit(state.copyWith(profile: event.profile));
  }

  Future<void> _loadModules(
      LoadModules event, Emitter<ModulesState> emit) async {
    emit(state.copyWith(modulesRequestState: const RequestState.loading()));

    await Future.delayed(const Duration(milliseconds: 200));

    final modulesRequestState = await _moduleRepository.getModules();

    super.handleRequestState(modulesRequestState);

    emit(state.copyWith(modulesRequestState: modulesRequestState));
  }

  @override
  void notify(Profile? profile) {
    add(ProfileLoadedFromGlobal(profile));
  }

  @override
  Future<void> close() async {
    globalProfileObservable.removeListener(this);
    super.close();
  }
}
