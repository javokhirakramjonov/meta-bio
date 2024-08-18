import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/ui/screen/auth/auth.dart';
import 'package:meta_bio/ui/screen/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FlutterSecureStorage _flutterSecureStorage;
  final SharedPreferences _sharedPreferences;

  SplashBloc(this._flutterSecureStorage, this._sharedPreferences)
      : super(const SplashState.initial()) {
    on<SplashStarted>((event, emit) async {
      var profile = _sharedPreferences.getString('profile');

      if (profile == null) {
        await _flutterSecureStorage.deleteAll();
      }

      var token = await _flutterSecureStorage.read(key: 'token');

      var nextScreen =
          token == null ? const AuthScreen() : const DashboardScreen();

      await Future.delayed(const Duration(seconds: 2), () {
        emit(SplashState.openScreen(nextScreen: nextScreen));
      });
    });
  }
}
