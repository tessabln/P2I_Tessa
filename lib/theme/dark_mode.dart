import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 34, 34, 34),
    primary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color.fromARGB(255, 51, 51, 51),
    inversePrimary: const Color.fromARGB(255, 255, 255, 255),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Color.fromARGB(255, 255, 255, 255),
        displayColor: const Color.fromARGB(255, 0, 0, 0),
      ),
);
