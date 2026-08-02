import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme/app_spacing.dart';
import '../constants/theme/app_typography.dart';

/// Morning Circadian Theme (5:00 AM – 11:00 AM)
/// Fresh sunrise aesthetic with soft cream background, warm golden yellow primary, and amber orange accents.

/// Morning Background Gradient
const LinearGradient morningGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFFFDF8), // Soft sunrise cream top
    Color(0xFFFFF4E5), // Subtle warm golden hue
    Color(0xFFFFE8CC), // Soft sunrise orange tint bottom
  ],
);

/// Morning Card Accent Gradient
const LinearGradient morningCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFFBF5),
    Color(0xFFFFF4E5),
  ],
);

/// Constructs the Morning [ThemeData]
ThemeData buildMorningTheme() {
  const primaryColor = Color(0xFFF6B93B); // Warm golden yellow
  const secondaryColor = Color(0xFFFA8231); // Warm sunrise orange
  const backgroundColor = Color(0xFFFFF9F0); // Soft warm cream
  const surfaceColor = Color(0xFFFFFBF5); // Cream white card surface
  const borderColor = Color(0xFFF3E8D9); // Gentle warm border

  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Color(0xFF2D251E),
    primaryContainer: Color(0xFFFFE8CC),
    onPrimaryContainer: Color(0xFF2D251E),
    secondary: secondaryColor,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFD8B3),
    onSecondaryContainer: Color(0xFF2D251E),
    surface: surfaceColor,
    onSurface: Color(0xFF2D251E),
    error: Color(0xFFEB3B5A),
    onError: Colors.white,
    outline: borderColor,
    shadow: Color(0x0CF6B93B),
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
      iconTheme: const IconThemeData(color: Color(0xFF2D251E)),
      titleTextStyle: AppTypography.headlineMedium.copyWith(color: const Color(0xFF2D251E)),
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
        foregroundColor: const Color(0xFF2D251E),
        disabledBackgroundColor: borderColor,
        disabledForegroundColor: const Color(0xFFA19A91),
        minimumSize: const Size.fromHeight(56.0),
        padding: AppSpacing.paddingHorizLg,
        textStyle: AppTypography.labelLarge.copyWith(color: const Color(0xFF2D251E)),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF2D251E),
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
      hintStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFFA19A91)),
      labelStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6E675F)),
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
