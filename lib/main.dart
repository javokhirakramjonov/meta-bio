import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/repository/auth_repository.dart';
import 'package:meta_bio/repository/exam_repository.dart';
import 'package:meta_bio/repository/module_repository.dart';
import 'package:meta_bio/service/api_service.dart';
import 'package:meta_bio/ui/screen/splash/splash.dart';
import 'package:meta_bio/ui/theme/my_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await justGetIt();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meta Bio',
      theme: ThemeData(
        colorScheme: darkTheme.colorScheme,
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      home: const SplashScreen(),
    );
  }
}

Future<void> justGetIt() async {
  GetIt.I.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  GetIt.I.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  GetIt.I.registerSingleton<ApiService>(ApiService(GetIt.I.get()));
  GetIt.I.registerSingleton<AuthRepository>(
      AuthRepository(GetIt.I.get(), GetIt.I.get(), GetIt.I.get()));
  GetIt.I.registerSingleton<ModuleRepository>(ModuleRepository(GetIt.I.get()));
  GetIt.I.registerSingleton<ExamRepository>(ExamRepository(GetIt.I.get()));
}
