import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color.fromARGB(255, 244, 244, 244),
    primary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color.fromARGB(255, 210, 205, 205),
    inversePrimary: Color.fromARGB(255, 255, 255, 255),
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: const Color.fromARGB(255, 0, 0, 0), 
  ),
);

