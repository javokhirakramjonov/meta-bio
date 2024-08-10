import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/ui/screen/auth/auth.dart';

part 'splash_event.dart';

part 'splash_state.dart';

part 'splash_bloc.freezed.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FlutterSecureStorage _flutterSecureStorage;

  SplashBloc(this._flutterSecureStorage) : super(const SplashState.initial()) {
    on<SplashStarted>((event, emit) async {
      var token = await _flutterSecureStorage.read(key: 'token');
      var nextScreen = token == null
          ? const AuthScreen()
          : const SizedBox();//TODO: Add the next screen after login

      await Future.delayed(const Duration(seconds: 3), () {
        emit(SplashState.openScreen(nextScreen: nextScreen));
      });
    });
  }
}
