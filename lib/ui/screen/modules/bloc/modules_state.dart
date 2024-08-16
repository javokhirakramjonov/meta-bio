part of 'modules_bloc.dart';

@freezed
class ModulesState with _$ModulesState {
  const factory ModulesState.initial({
    Profile? profile,
    @Default(RequestState.initial())
    RequestState<List<Module>> modulesRequestState,
  }) = _Initial;
}
