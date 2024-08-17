import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingView(BuildContext context) {
  return Stack(
    children: [
      Positioned.fill(
        child: Blur(
          blur: 3.0,
          colorOpacity: 0.1,
          blurColor: Theme.of(context).colorScheme.primary,
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),

      // Centered Circular Loading Indicator
      Center(
        child: SpinKitCircle(
          color: Theme.of(context).colorScheme.primary,
          size: 80.0,
        ),
      ),
    ],
  );
}
