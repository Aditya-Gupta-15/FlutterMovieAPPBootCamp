import 'package:flutter/material.dart';

enum AppTheme {
  light,
  dark,
}

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.light: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(color: Colors.blue), 

  ),
  AppTheme.dark: ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.deepPurple.shade700,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: Colors.deepPurple,
    textTheme: ButtonTextTheme.primary,
  ),

  iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
)
};