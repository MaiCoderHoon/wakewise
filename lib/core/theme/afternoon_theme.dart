import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme/app_spacing.dart';
import '../constants/theme/app_typography.dart';

/// Afternoon Circadian Theme (11:00 AM – 5:00 PM)
/// Premium Dark Focus Mode inspired by Linear & Nothing OS.
/// Elegant, productive, modern dark theme with golden amber focus accents.

/// Afternoon Background Gradient (Linear & Nothing OS dark focus mode)
const LinearGradient afternoonGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF1A1F2C), // Deep obsidian slate top
    Color(0xFF2A3245), // Premium dark focus slate bottom
  ],
);

/// Afternoon Card Accent Gradient
const LinearGradient afternoonCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF252B3B),
    Color(0xFF1F2430),
  ],
);

/// Constructs the Afternoon [ThemeData]
ThemeData buildAfternoonTheme() {
  const primaryColor = Color(0xFFF6B93B); // Golden yellow primary
  const secondaryColor = Color(0xFFFDBA3B); // Warm amber accent
  const backgroundColor = Color(0xFF161A23); // Premium Linear dark background
  const surfaceColor = Color(0xFF1F2430); // Elevated dark card surface
  const borderColor = Color(0xFF2C3446); // Dark obsidian border

  const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: Color(0xFF161A23),
    primaryContainer: Color(0xFF332B1A),
    onPrimaryContainer: Color(0xFFFDE68A),
    secondary: secondaryColor,
    onSecondary: Color(0xFF161A23),
    secondaryContainer: Color(0xFF45300F),
    onSecondaryContainer: Color(0xFFFEF3C7),
    surface: surfaceColor,
    onSurface: Color(0xFFF8FAFC),
    error: Color(0xFFEF4444),
    onError: Color(0xFF161A23),
    outline: borderColor,
    shadow: Color(0x33000000),
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
        foregroundColor: const Color(0xFF161A23),
        disabledBackgroundColor: borderColor,
        disabledForegroundColor: const Color(0xFF64748B),
        minimumSize: const Size.fromHeight(56.0),
        padding: AppSpacing.paddingHorizLg,
        textStyle: AppTypography.labelLarge.copyWith(color: const Color(0xFF161A23)),
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
      foregroundColor: const Color(0xFF161A23),
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
