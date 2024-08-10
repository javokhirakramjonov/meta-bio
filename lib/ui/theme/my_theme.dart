import 'package:flutter/material.dart';

const primary1 = Color(0xFF17A67B);
const primary2 = Color(0xFF13D2C8);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: primary1,
    onPrimary: Colors.white,
    secondary: primary2,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: primary1,
    onPrimary: Colors.black,
    secondary: primary2,
    onSecondary: Colors.white,
    surface: Color(0xFF0D0D0D),
    onSurface: Colors.white,
  ),
);
