import 'package:flutter/material.dart';

class AppColors {
  // Primary color (used for buttons, highlights, etc.)
  static const Color primary = Color(0xFF6C63FF); // purple-ish accent

  // Accent or secondary color
  static const Color secondary = Color(0xFF00BFA6); // teal accent



  // Neutral colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Dynamic background color based on theme
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212) // dark background
          : const Color(0xFFF5F5F5); // light background

  // Dynamic text color based on theme
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black87;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[400]!
          : Colors.grey[700]!;

  // Card color
  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : Colors.white;

  // Border or divider color
  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[300]!;

  // Button background (same for both modes)
  static Color button = primary;

  // Button text color
  static Color buttonText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.white;
}
