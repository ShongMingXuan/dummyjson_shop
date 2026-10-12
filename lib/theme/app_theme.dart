import 'package:flutter/material.dart';

class AppTheme {
  static const white = Color(0xFFFFFFFF);
  static const lightPink = Color(0xFFFFE4F0);
  static const lightBlue = Color(0xFFE3F5FD);
  static const lightGreen = Color(0xFFE6F9EC);
  static const bandColors = [white, lightPink, lightBlue, lightGreen];

  static const brandGradient = LinearGradient(
    colors: [white, lightPink, lightBlue, lightGreen],
    stops: [0.0, 0.33, 0.66, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
);
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: lightPink,
      brightness: Brightness.light,
    ).copyWith(secondary: lightBlue, tertiary: lightGreen);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFFFFAFD), // white with a faint pink tint
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // so the gradient shows
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightBlue,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}