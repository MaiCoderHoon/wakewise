import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme/app_spacing.dart';
import '../constants/theme/app_typography.dart';

/// Evening Circadian Theme (5:00 PM – 8:00 PM)
/// Warm sunset palette featuring deep orange, muted purple, and soft amber twilight hues.

/// Evening Background Gradient (Sunset peach to muted purple transition)
const LinearGradient eveningGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFFE0B2), // Soft sunset peach top
    Color(0xFFF8BBD0), // Soft sunset rose middle
    Color(0xFFD1C4E9), // Muted twilight purple bottom
  ],
);

/// Evening Card Accent Gradient
const LinearGradient eveningCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFFBF9),
    Color(0xFFF3E5F5),
  ],
);

/// Constructs the Evening [ThemeData]
ThemeData buildEveningTheme() {
  const primaryColor = Color(0xFF6A1B9A); // Deep muted purple
  const secondaryColor = Color(0xFFE65100); // Deep sunset orange
  const backgroundColor = Color(0xFFFAF3F0); // Soft sunset background tint
  const surfaceColor = Color(0xFFFFFBF9); // Warm card surface
  const borderColor = Color(0xFFE1BEE7); // Muted purple border

  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFF3E5F5),
    onPrimaryContainer: Color(0xFF4A148C),
    secondary: secondaryColor,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFCC80),
    onSecondaryContainer: Color(0xFFBF360C),
    surface: surfaceColor,
    onSurface: Color(0xFF2C1A32),
    error: Color(0xFFC62828),
    onError: Colors.white,
    outline: borderColor,
    shadow: Color(0x1A6A1B9A),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: AppTypography.textTheme,
    fontFamily: AppTypography.displayLarge.fontFamily,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Color(0xFF2C1A32)),
      titleTextStyle: AppTypography.headlineMedium.copyWith(color: const Color(0xFF2C1A32)),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
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
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFE0E0E0),
        minimumSize: const Size.fromHeight(56.0),
        padding: AppSpacing.paddingHorizLg,
        textStyle: AppTypography.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF2C1A32),
        minimumSize: const Size.fromHeight(56.0),
        padding: AppSpacing.paddingHorizLg,
        textStyle: AppTypography.labelLarge,
        side: const BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLg,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: AppSpacing.paddingAllMd,
      hintStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF9E9E9E)),
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
