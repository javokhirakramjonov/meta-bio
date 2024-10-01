import 'package:flutter/material.dart';

const primary = Color(0xFF17A67B);
const secondary = Color(0xFF13D2C8);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: primary,
    onPrimary: Colors.black,
    secondary: secondary,
    onSecondary: Colors.white,
    surface: Color(0xFF0D0D0D),
    onSurface: Colors.white,
    error: Color(0xFFF78888),
  ),
);
