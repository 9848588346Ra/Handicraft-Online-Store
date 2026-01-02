import 'package:flutter/material.dart';

// Handicraft Theme Colors
class HandicraftColors {
  // Primary colors - Warm terracotta/orange-brown
  static const Color primary = Color(0xFFD2691E); // Chocolate/terracotta
  static const Color primaryDark = Color(0xFFB85C1A);
  static const Color primaryLight = Color(0xFFE8A87C);
  
  // Secondary colors - Deep teal/forest green
  static const Color secondary = Color(0xFF2D5016); // Forest green
  static const Color secondaryLight = Color(0xFF4A7C2A);
  
  // Accent colors
  static const Color accent = Color(0xFFCD853F); // Peru/tan
  static const Color accentLight = Color(0xFFF4A460); // Sandy brown
  
  // Background colors
  static const Color background = Color(0xFFFDF8F3); // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  
  // Text colors
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B6B6B);
  
  // Border colors
  static const Color borderLight = Color(0xFFE0D5C7);
  static const Color borderFocus = primary;
}

ThemeData getApplicationTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: HandicraftColors.primary,
      primary: HandicraftColors.primary,
      secondary: HandicraftColors.secondary,
      surface: HandicraftColors.surface,
      background: HandicraftColors.background,
    ),
    useMaterial3: true,
    fontFamily: "open sans regular",
    scaffoldBackgroundColor: HandicraftColors.background,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: "open sans regular",
        ),
        backgroundColor: HandicraftColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 2,
      ),
    ),
  );
}