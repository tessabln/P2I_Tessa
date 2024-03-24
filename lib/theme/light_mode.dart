import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color.fromARGB(255, 244, 244, 244),
    primary: Color.fromARGB(255, 76, 61, 120),
    secondary: Color.fromARGB(255, 255, 255, 255),
    inversePrimary: Color.fromARGB(255, 0, 0, 0),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: const Color.fromARGB(255, 0, 0, 0),
      ),
);
