import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:blur/blur.dart';

Widget loadingView(BuildContext context) {
  return Stack(
      children: [
        Positioned.fill(
          child: Blur(
            blur: 3.0,
            colorOpacity: 0.1,
            blurColor: Theme.of(context).primaryColor,
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),

        // Centered Circular Loading Indicator
        Center(
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 80.0,
          ),
        ),
      ],
  );
}