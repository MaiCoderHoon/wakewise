import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// WakeWise Light Theme Configuration
/// Material 3 theme with warm sunrise aesthetic.
ThemeData get lightThemeData {
  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.textPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textOnSecondary,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: AppColors.error,
    onError: Colors.white,
    outline: AppColors.border,
    outlineVariant: AppColors.borderFocused,
    shadow: Color(0x0C8C420D),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTypography.textTheme,
    fontFamily: AppTypography.displayLarge.fontFamily,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: AppTypography.headlineMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLg, // 24px rounded corners
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.border,
        disabledForegroundColor: AppColors.textMuted,
        minimumSize: const Size.fromHeight(56.0),
        padding: AppSpacing.paddingHorizLg,
        textStyle: AppTypography.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl, // 32px rounded corners
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size.fromHeight(56.0),
        padding: AppSpacing.paddingHorizLg,
        textStyle: AppTypography.labelLarge,
        side: const BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondary,
        textStyle: AppTypography.labelLarge,
        padding: AppSpacing.paddingHorizMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.textOnSecondary,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLg,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: AppSpacing.paddingAllMd,
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
      labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
    ),

    // Bottom Navigation Bar / NavigationBar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryLight.withValues(alpha: 0.5),
      elevation: 0,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          );
        }
        return AppTypography.labelSmall.copyWith(color: AppColors.textSecondary);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.textPrimary);
        }
        return const IconThemeData(color: AppColors.textSecondary);
      }),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
  );
}
