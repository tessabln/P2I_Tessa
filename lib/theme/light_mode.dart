import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color.fromARGB(255, 135, 129, 146),
    primary: const Color.fromARGB(255, 0, 0, 0),
    secondary: Color.fromARGB(255, 210, 205, 205),
    inversePrimary: Color.fromARGB(255, 57, 51, 51),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: const Color.fromARGB(255, 0, 0, 0),
        displayColor: Colors.black,
      ),
);
//Color.fromARGB(255, 129, 122, 142),