import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_bio/ui/screen/splash/bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const SplashEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
