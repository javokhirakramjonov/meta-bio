part of 'modules_bloc.dart';

@freezed
class ModulesEvent with _$ModulesEvent {
  const factory ModulesEvent.started() = Started;

  const factory ModulesEvent.profileLoadedFromGlobal(Profile? profile) =
      ProfileLoadedFromGlobal;

  const factory ModulesEvent.loadModules() = LoadModules;
}
