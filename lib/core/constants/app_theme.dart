import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: AppColors.background,
      onPrimary: AppColors.textWhite,
      onSecondary: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
      onSurface: AppColors.textSecondary,
      error: Colors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.accent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.primary),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.borderDefault,
    ),
  );
}
