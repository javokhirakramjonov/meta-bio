import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/auth_repository.dart';
import 'package:meta_bio/util/request_state_error_handler_bloc.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends RequestStateHandlerBloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository, context)
      : super(const AuthState.state(), context) {
    on<PhoneNumberChanged>((event, emit) async {
      emit(state.copyWith(phoneNumber: event.newPhoneNumber));
    });
    on<PasswordChanged>((event, emit) async {
      emit(state.copyWith(password: event.newPassword));
    });
    on<ToggledPasswordVisibility>((event, emit) async {
      emit(state.copyWith(isPasswordVisible: event.isPasswordVisible));
    });
    on<LoginClicked>(_login);
  }

  Future<void> _login(LoginClicked event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginRequestState: const RequestStateLoading()));

    RequestState<void> loginRequestState =
        await _authRepository.login(state.phoneNumber, state.password);

    super.handleRequestState(loginRequestState,
        successMessage: 'Successfully logged in');

    emit(state.copyWith(loginRequestState: loginRequestState));
  }
}
