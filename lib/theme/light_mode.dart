import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: const Color.fromARGB(255, 0, 0, 0),
    secondary: Colors.grey.shade400,
    inversePrimary: const Color.fromARGB(255, 106, 104, 104),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: const Color.fromARGB(255, 0, 0, 0),
        displayColor: Colors.black,
      ),
);
