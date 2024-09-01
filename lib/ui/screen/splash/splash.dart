import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_bio/ui/screen/splash/bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  final bool logOut;

  const SplashScreen({super.key, this.logOut = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SplashBloc(GetIt.I.get(), GetIt.I.get(), GetIt.I.get(), widget.logOut)
            ..add(const SplashEvent.started()),
      child: Scaffold(
        body: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashOpenNextScreen) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => state.nextScreen),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: Lottie.asset('assets/animations/splash.json'),
            );
          },
        ),
      ),
    );
  }
}
