import 'package:flutter/material.dart';
import 'package:meta_bio/ui/screen/splash/bloc/splash_bloc.dart';
import 'package:meta_bio/ui/screen/splash/splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SplashBloc()),
        ],
        child: MaterialApp(
          title: 'Meta Bio',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF13D2C8)),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ));
  }
}
