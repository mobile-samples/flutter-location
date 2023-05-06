import 'package:flutter/material.dart';

ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  return ThemeData(
    scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
    appBarTheme: Theme.of(context).appBarTheme.copyWith(
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
    textTheme: Theme.of(context).textTheme.copyWith(
          titleLarge: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          titleMedium: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          headlineMedium: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600),
          labelSmall: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w500),
        ),
    cardTheme: Theme.of(context).cardTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color.fromARGB(240, 240, 240, 240),
        ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
        foregroundColor: MaterialStateProperty.all(Colors.green),
      ),
    ),
    colorScheme: Theme.of(context).colorScheme.copyWith(
        background: isDarkTheme ? Colors.black : Colors.white,
        primary: Colors.green,
        secondary: Colors.grey,
        tertiary: Colors.amber),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        // textStyle: TextStyle(color: Colors.green),
        foregroundColor: Colors.green,
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.green[200],
    ),
  );
}
