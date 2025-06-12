import 'package:flutter/material.dart';

/// Centralized color constants for the app theme and branding.
/// Add or edit color values here for global reuse.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary brand color
  static const Color primary = Color(0xFF15095B); // Deep Purple

  // Accent / Highlight colors
  static const Color accent = Color(0xFFD9D9D9); // Light gray (e.g., button bg)
  static const Color selectedCard = Color(0xFFEDE7F6); // Light purple shade

  // Text colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.black87;
  static const Color textWhite = Colors.white;

  // Border colors
  static const Color borderDefault = Colors.grey;

  // Shadow
  static const Color shadow = Colors.deepPurple;

  // Backgrounds
  static const Color background = Colors.white;
  static const Color containerOverlay = Color.fromRGBO(21, 9, 91, 0.9);

  static const Color surface = Colors.white;
}
