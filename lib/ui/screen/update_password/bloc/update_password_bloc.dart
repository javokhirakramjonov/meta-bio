import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_password_bloc.freezed.dart';
part 'update_password_event.dart';
part 'update_password_state.dart';

class UpdatePasswordBloc
    extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  UpdatePasswordBloc() : super(const UpdatePasswordState.initial()) {
    on<OldPasswordChanged>(_oldPasswordChanged);
    on<NewPasswordChanged>(_newPasswordChanged);
    on<ToggleOldPasswordVisibility>(_toggleOldPasswordVisibility);
    on<ToggleNewPasswordVisibility>(_toggleNewPasswordVisibility);
  }

  void _oldPasswordChanged(
      OldPasswordChanged event, Emitter<UpdatePasswordState> emit) async {
    emit(state.copyWith(oldPassword: event.oldPassword));
  }

  void _newPasswordChanged(
      NewPasswordChanged event, Emitter<UpdatePasswordState> emit) async {
    emit(state.copyWith(newPassword: event.newPassword));
  }

  void _toggleOldPasswordVisibility(ToggleOldPasswordVisibility event,
      Emitter<UpdatePasswordState> emit) async {
    emit(state.copyWith(isOldPasswordVisible: event.newVisibility));
  }

  void _toggleNewPasswordVisibility(ToggleNewPasswordVisibility event,
      Emitter<UpdatePasswordState> emit) async {
    emit(state.copyWith(isNewPasswordVisible: event.newVisibility));
  }
}
