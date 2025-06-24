import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color primaryColor = Color(0xFF1A3957);
  static const Color secondaryColor = Color(0xFF77BEFD);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFFF6F6F6);
  static const Color sidebarColor = Color(0xF8F8F8FF);

  // Dimension colors
  static const Color physicalColor = Color(0xFF193958);
  static const Color environmentalColor = Color(0xFF36638D);
  static const Color socialColor = Color(0xFF558EC4);
  static const Color emotionalColor = Color(0xFF75BDFF);
  static const Color intellectualColor = Color(0xFF77C0EA);
  static const Color occupationalColor = Color(0xFF7AC4CC);
  static const Color spiritualColor = Color(0xFF7CC8B1);
  static const Color financialColor = Color(0xFF7FCC92);
  // static const Color healthColor = Color(0xFF7FCC92);
  
  // Status colors
  static const Color redColor = Color(0xFFE74C3C);
  static const Color orangeColor = Color(0xFFFF9436);
  static const Color yellowColor = Color(0xFFF9E94A);
  static const Color greenLightColor = Color(0xFFADE04C);
  static const Color greenColor = Color(0xFF66CC66);
  
  // Text colors
  static const Color textDarkColor = Color(0xFF333333);
  static const Color textMediumColor = Color(0xFF666666);
  static const Color textLightColor = Color(0xFF999999);

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textDarkColor),
      displayMedium: TextStyle(color: textDarkColor),
      displaySmall: TextStyle(color: textDarkColor),
      headlineLarge: TextStyle(color: textDarkColor),
      headlineMedium: TextStyle(color: textDarkColor),
      headlineSmall: TextStyle(color: textDarkColor),
      titleLarge: TextStyle(color: textDarkColor),
      titleMedium: TextStyle(color: textMediumColor),
      titleSmall: TextStyle(color: textMediumColor),
      bodyLarge: TextStyle(color: textDarkColor),
      bodyMedium: TextStyle(color: textMediumColor),
      bodySmall: TextStyle(color: textLightColor),
      labelLarge: TextStyle(color: textDarkColor),
      labelMedium: TextStyle(color: textMediumColor),
      labelSmall: TextStyle(color: textLightColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textDarkColor,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      buttonColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}