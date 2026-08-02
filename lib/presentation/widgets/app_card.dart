import 'package:flutter/material.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_shadows.dart';
import '../../core/constants/theme/app_spacing.dart';

/// WakeWise Reusable Card Component
/// Theme-adapted card surface with large rounded corners (24-28px), subtle glowing border, and ambient shadow.
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

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.paddingAllLg,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.boxShadow,
    this.borderRadius = AppSpacing.radiusLg, // 24px rounded corners default
    this.border,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Preset for elevated hero/accent cards with subtle sunrise/theme tint
  factory AppCard.accent({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry padding = AppSpacing.paddingAllLg,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    double borderRadius = AppSpacing.radiusLg,
  }) {
    return AppCard(
      key: key,
      padding: padding,
      margin: margin,
      onTap: onTap,
      gradient: AppColors.cardAccentGradient,
      border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.6), width: 1.5),
      boxShadow: AppShadows.card,
      borderRadius: borderRadius,
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
    return AppCard(
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
    return AppCard(
      key: key,
      padding: padding,
      margin: margin,
      onTap: onTap,
      gradient: AppColors.primaryGradient,
      boxShadow: AppShadows.buttonGlow,
      borderRadius: borderRadius,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;
    final effectiveBorderRadius = BorderRadius.circular(borderRadius);

    final effectiveBgColor = backgroundColor ?? cardTheme.color ?? theme.colorScheme.surface;
    final effectiveBorder = border ?? Border.all(
      color: theme.colorScheme.outline.withValues(alpha: 0.5),
      width: 1.0,
    );

    Widget cardBody = Container(
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      cardBody = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
          child: cardBody,
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? effectiveBgColor : null,
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        border: effectiveBorder,
        boxShadow: boxShadow ?? AppShadows.soft,
      ),
      clipBehavior: clipBehavior,
      child: cardBody,
    );
  }
}
