import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.blueGrey[900],
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 11, 73, 124),
      ));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
      ));
}
