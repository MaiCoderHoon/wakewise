import 'package:flutter/material.dart';

/// WakeWise Color Palette
/// Sunrise aesthetic with soft cream, sunny yellow, and warm orange accents.
abstract class AppColors {
  // Brand Core Colors
  static const Color background = Color(0xFFFFF8EE); // Soft cream
  static const Color primary = Color(0xFFF8B133); // Sunny yellow
  static const Color primaryDark = Color(0xFFE09B1C); // Deep sunny yellow
  static const Color primaryLight = Color(0xFFFCD680); // Light golden yellow
  static const Color secondary = Color(0xFFFF8C42); // Warm orange
  static const Color secondaryDark = Color(0xFFE56A1B); // Rich amber orange
  static const Color secondaryLight = Color(0xFFFFB380); // Sunrise orange tint

  // Neutral & Surface Colors
  static const Color surface = Color(0xFFFFFBF5); // Cream white card surface
  static const Color surfaceElevated = Color(0xFFFFFFFF); // Pure white floating surface
  static const Color surfaceSubtle = Color(0xFFFFF3E0); // Soft warm orange tint background
  static const Color border = Color(0xFFF0E6D8); // Gentle warm divider/border
  static const Color borderFocused = Color(0xFFE5D5C0); // Darker border for focus states

  // Typography Colors
  static const Color textPrimary = Color(0xFF1F1C18); // High contrast warm charcoal
  static const Color textSecondary = Color(0xFF6E675F); // Medium contrast warm slate
  static const Color textMuted = Color(0xFFA19A91); // Soft muted text
  static const Color textOnPrimary = Color(0xFF2C2200); // Rich dark text over yellow button
  static const Color textOnSecondary = Color(0xFFFFFFFF); // White text over orange button

  // Status & Feedback Colors
  static const Color success = Color(0xFF52B788); // Soft mint green
  static const Color warning = Color(0xFFF4A261); // Soft warm amber
  static const Color error = Color(0xFFE65100); // Warm terracotta red
  static const Color info = Color(0xFF4EA8DE); // Warm morning sky blue

  // Sunrise Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF8EE), // Soft cream top
      Color(0xFFFFF3E0), // Subtle warm golden hue bottom
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF8B133), // Sunny yellow
      Color(0xFFFF8C42), // Warm orange accent
    ],
  );

  static const LinearGradient cardAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFBF5),
      Color(0xFFFFF3E0),
    ],
  );
}
