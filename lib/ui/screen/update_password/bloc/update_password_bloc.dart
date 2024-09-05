import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/auth_repository.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'update_password_bloc.freezed.dart';
part 'update_password_event.dart';
part 'update_password_state.dart';

class UpdatePasswordBloc
    extends RequestStateHandlerBloc<UpdatePasswordEvent, UpdatePasswordState> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;

  UpdatePasswordBloc(this._authRepository, this._secureStorage, context)
      : super(const UpdatePasswordState.initial(), context) {
    on<OldPasswordChanged>(_oldPasswordChanged);
    on<NewPasswordChanged>(_newPasswordChanged);
    on<ToggleOldPasswordVisibility>(_toggleOldPasswordVisibility);
    on<ToggleNewPasswordVisibility>(_toggleNewPasswordVisibility);
    on<ValidateOldPassword>(_validateOldPassword);
    on<UpdatePassword>(_updatePassword);
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

  void _validateOldPassword(
      ValidateOldPassword event, Emitter<UpdatePasswordState> emit) async {
    final oldPassword = await _secureStorage.read(key: 'password');

    final isValid = state.oldPassword == oldPassword;

    emit(state.copyWith(isOldPasswordValid: isValid));
  }

  void _updatePassword(
      UpdatePassword event, Emitter<UpdatePasswordState> emit) async {
    emit(state.copyWith(
        updatePasswordRequestState: const RequestState.loading()));

    final requestState =
        await _authRepository.updatePassword(state.newPassword);

    super.handleRequestState(requestState,
        successMessage: 'Successfully updated the password');

    emit(state.copyWith(updatePasswordRequestState: requestState));
  }
}
