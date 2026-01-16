import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors from Design
  static const Color primaryColor = Color(0xFFCE1330); // Red accent
  static const Color primaryLight = Color(0xFFFFE4E1); // Light pink
  static const Color primaryDark = Color(0xFFB71C1C); // Dark red

  // Background Colors - All same linen/beige #FAF0E6
  static const Color backgroundColor = Color(0xFFFAF0E6); // Linen
  static const Color surfaceColor = Color(0xFFFAF0E6); // Same linen
  static const Color cardColor = Colors.white;

  // Brown Colors
  static const Color brownPrimary = Color(
    0xFF412216,
  ); // Dark brown (text/icons)
  static const Color brownSecondary = Color(0xFF9B806E); // Brown secondary
  static const Color brownLight = Color(0xFFE1D6CE); // Light tan

  // Text Colors
  static const Color textPrimary = Color(0xFF412216); // Dark brown
  static const Color textSecondary = Color(0xFF9B806E); // Brown secondary
  static const Color textLight = Color(0xFFBDBDBD); // Grey

  // Other Colors
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: brownPrimary,
        surface: surfaceColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Cairo',
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: brownPrimary,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
