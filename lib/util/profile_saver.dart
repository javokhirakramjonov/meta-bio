import 'dart:convert';

import 'package:meta_bio/domain/profile.dart';
import 'package:meta_bio/util/global.dart';
import 'package:meta_bio/util/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSaver implements Observer<Profile?> {
  final SharedPreferences _sharedPreferences;

  ProfileSaver(this._sharedPreferences);

  void start() {
    globalProfileObservable.addListener(this);
  }

  @override
  void notify(Profile? profile) async {
    if (profile == null) {
      await _sharedPreferences.remove('profile');
    } else {
      await _sharedPreferences.setString('profile', jsonEncode(profile));
    }
  }
}
