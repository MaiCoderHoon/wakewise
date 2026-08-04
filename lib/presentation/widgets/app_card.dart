import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_shadows.dart';
import '../../core/constants/theme/app_spacing.dart';

/// WakeWise Reusable Card Component
/// Theme-adapted glass card surface with large rounded corners, liquid glass blur, and specular highlights.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final double borderRadius;
  final Border? border;
  final Clip clipBehavior;

  // Internal flags for factory variants
  final bool _isAccent;
  final bool _isPrimary;

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.paddingAllLg,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.boxShadow,
    this.borderRadius = AppSpacing.radiusLg,
    this.border,
    this.clipBehavior = Clip.antiAlias,
  })  : _isAccent = false,
        _isPrimary = false;

  /// Preset for elevated hero/accent cards with subtle sunrise/theme tint
  factory AppCard.accent({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry padding = AppSpacing.paddingAllLg,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    double borderRadius = AppSpacing.radiusLg,
  }) {
    return AppCard._variant(
      key: key,
      padding: padding,
      margin: margin,
      onTap: onTap,
      gradient: AppColors.cardAccentGradient,
      border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.6), width: 1.5),
      boxShadow: AppShadows.card,
      borderRadius: borderRadius,
      isAccent: true,
      child: child,
    );
  }

  /// Frosted glass card for hero sections overlaying a gradient background
  factory AppCard.glass({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry padding = AppSpacing.paddingAllLg,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    double borderRadius = AppSpacing.radiusLg,
    Color glassColor = const Color(0x26FFFFFF),
  }) {
    return AppCard._variant(
      key: key,
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: glassColor,
      border: Border.all(color: const Color(0x33FFFFFF), width: 1.0),
      boxShadow: AppShadows.medium,
      borderRadius: borderRadius,
      child: child,
    );
  }

  /// Solid gradient card using the primary gradient (e.g., Morning Quest banner)
  factory AppCard.primary({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry padding = AppSpacing.paddingAllLg,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    double borderRadius = AppSpacing.radiusLg,
  }) {
    return AppCard._variant(
      key: key,
      padding: padding,
      margin: margin,
      onTap: onTap,
      gradient: AppColors.primaryGradient,
      boxShadow: AppShadows.buttonGlow,
      borderRadius: borderRadius,
      isPrimary: true,
      child: child,
    );
  }

  /// Internal named constructor used by factories to carry variant flags.
  const AppCard._variant({
    super.key,
    required this.child,
    this.padding = AppSpacing.paddingAllLg,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.boxShadow,
    this.borderRadius = AppSpacing.radiusLg,
    this.border,
    bool isAccent = false,
    bool isPrimary = false,
  })  : clipBehavior = Clip.antiAlias,
        _isAccent = isAccent,
        _isPrimary = isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    // ── Glass settings per variant ──────────────────────────────────────────
    final Color tint;
    final double blur;
    final double thickness;
    final Color? backerColor;

    if (_isAccent) {
      // Accent: primary-tinted, slightly richer blur
      tint = primaryColor.withValues(alpha: isDark ? 0.10 : 0.07);
      blur = isDark ? 20 : 16;
      thickness = isDark ? 44 : 32;
      backerColor = null;
    } else if (_isPrimary) {
      // Primary: gradient backer keeps the vivid colour, glass adds shimmer
      tint = primaryColor.withValues(alpha: isDark ? 0.12 : 0.08);
      blur = isDark ? 18 : 14;
      thickness = isDark ? 40 : 28;
      backerColor = primaryColor.withValues(alpha: 0.55);
    } else {
      // Standard / glass: neutral frosted look
      tint = primaryColor.withValues(alpha: isDark ? 0.07 : 0.05);
      blur = isDark ? 16 : 12;
      thickness = isDark ? 36 : 24;
      backerColor = null;
    }

    // ── Inner content ───────────────────────────────────────────────────────
    Widget content = Padding(padding: padding, child: child);

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: primaryColor.withValues(alpha: 0.12),
        highlightColor: primaryColor.withValues(alpha: 0.05),
        child: content,
      );
    }

    // ── Glass card ──────────────────────────────────────────────────────────
    Widget card = AdaptiveLiquidGlassLayer(
      child: GlassCard(
        quality: GlassQuality.standard,
        settings: LiquidGlassSettings(
          blur: blur,
          thickness: thickness,
          glassColor: tint,
          specularSharpness: GlassSpecularSharpness.medium,
          backerColor: backerColor,
        ),
        shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
        padding: EdgeInsets.zero, // padding is on the content widget
        child: content,
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}
