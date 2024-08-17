import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/repository/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState.initial()) {
    on<AuthPhoneNumberChanged>((event, emit) async {
      emit(state.copyWith(phoneNumber: event.newPhoneNumber));
    });
    on<AuthPasswordChanged>((event, emit) async {
      emit(state.copyWith(password: event.newPassword));
    });
    on<AuthToggledPasswordVisibility>((event, emit) async {
      emit(state.copyWith(isPasswordVisible: event.isPasswordVisible));
    });
    on<AuthLoginClicked>(_login);
  }

  Future<void> _login(AuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginRequestState: const RequestState.loading()));

    RequestState<void> loginRequestState =
        await _authRepository.login(state.phoneNumber, state.password);

    emit(state.copyWith(loginRequestState: loginRequestState));
  }
}
