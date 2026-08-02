import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme/app_spacing.dart';
import '../constants/theme/app_typography.dart';

/// Night Circadian Theme (8:00 PM – 5:00 AM)
/// Deep navy / indigo night palette with glassmorphic dark card surfaces & soft blue moonlit accents.

/// Night Background Gradient (Deep navy/midnight blue to midnight abyss)
const LinearGradient nightGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF0F172A), // Deep navy top
    Color(0xFF1E1B4B), // Midnight indigo
    Color(0xFF060A12), // Deep midnight abyss bottom
  ],
);

/// Night Card Accent Gradient (Glassmorphic dark card gradient)
const LinearGradient nightCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0x331E293B),
    Color(0x1F161F33),
  ],
);

/// Constructs the Night [ThemeData]
ThemeData buildNightTheme() {
  const primaryColor = Color(0xFF818CF8); // Moonlit indigo-violet
  const secondaryColor = Color(0xFF38BDF8); // Soft blue moonlit accent
  const backgroundColor = Color(0xFF080C14); // Midnight abyss background
  const surfaceColor = Color(0xFF161F33); // Glassmorphic dark card surface
  const borderColor = Color(0xFF25334D); // Soft blue dark border

  const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: Color(0xFF080C14),
    primaryContainer: Color(0xFF312E81),
    onPrimaryContainer: Color(0xFFE0E7FF),
    secondary: secondaryColor,
    onSecondary: Color(0xFF080C14),
    secondaryContainer: Color(0xFF075985),
    onSecondaryContainer: Color(0xFFE0F2FE),
    surface: surfaceColor,
    onSurface: Color(0xFFF8FAFC),
    error: Color(0xFFF87171),
    onError: Color(0xFF080C14),
    outline: borderColor,
    shadow: Color(0x40000000),
  );

  final darkTextTheme = AppTypography.textTheme.apply(
    bodyColor: const Color(0xFFF8FAFC),
    displayColor: const Color(0xFFF8FAFC),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: darkTextTheme,
    fontFamily: AppTypography.displayLarge.fontFamily,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Color(0xFFF8FAFC)),
      titleTextStyle: AppTypography.headlineMedium.copyWith(color: const Color(0xFFF8FAFC)),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),

    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLg,
        side: const BorderSide(color: borderColor, width: 1),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: const Color(0xFF080C14),
        disabledBackgroundColor: borderColor,
        disabledForegroundColor: const Color(0xFF64748B),
        minimumSize: const Size.fromHeight(56.0),
        padding: AppSpacing.paddingHorizLg,
        textStyle: AppTypography.labelLarge.copyWith(color: const Color(0xFF080C14)),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFFF8FAFC),
        minimumSize: const Size.fromHeight(56.0),
        padding: AppSpacing.paddingHorizLg,
        textStyle: AppTypography.labelLarge.copyWith(color: const Color(0xFFF8FAFC)),
        side: const BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: const Color(0xFF080C14),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLg,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: AppSpacing.paddingAllMd,
      hintStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF64748B)),
      labelStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF94A3B8)),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: borderColor,
      thickness: 1,
      space: 1,
    ),
  );
}
