import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/repository/auth_repository.dart';
import 'package:meta_bio/ui/screen/auth/auth.dart';
import 'package:meta_bio/ui/screen/dashboard/dashboard.dart';
import 'package:meta_bio/util/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FlutterSecureStorage _flutterSecureStorage;
  final SharedPreferences _sharedPreferences;
  final AuthRepository _authRepository;
  final bool logOut;

  SplashBloc(this._flutterSecureStorage, this._sharedPreferences,
      this._authRepository, this.logOut)
      : super(const SplashState.state()) {
    on<SplashStarted>((event, emit) async {
      var profileJson = _sharedPreferences.getString('profile');

      if (profileJson == null || logOut) {
        await _authRepository.logout();
      } else {
        final profile = Profile.fromJson(jsonDecode(profileJson));

        globalProfileObservable.value = profile;
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
