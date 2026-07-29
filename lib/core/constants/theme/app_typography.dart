import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// WakeWise Typography System
/// Built with Plus Jakarta Sans for a modern, clean, and legible aesthetic.
abstract class AppTypography {
  static TextStyle get _baseFont => GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimary,
      );

  // Display Styles (Large hero headers, time displays)
  static TextStyle displayLarge = _baseFont.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    height: 1.15,
    letterSpacing: -0.8,
  );

  static TextStyle displayMedium = _baseFont.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle displaySmall = _baseFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  // Headline Styles (Section headers, card titles)
  static TextStyle headlineLarge = _baseFont.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle headlineMedium = _baseFont.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle headlineSmall = _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Title Styles (List titles, dialog titles, button labels)
  static TextStyle titleLarge = _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );

  static TextStyle titleMedium = _baseFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle titleSmall = _baseFont.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Styles (Paragraphs, descriptions, AI text)
  static TextStyle bodyLarge = _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = _baseFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = _baseFont.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textMuted,
  );

  // Label / Button Styles
  static TextStyle labelLarge = _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = _baseFont.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.2,
  );

  static TextStyle labelSmall = _baseFont.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
  );

  /// Material 3 TextTheme instance configured with Plus Jakarta Sans
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
