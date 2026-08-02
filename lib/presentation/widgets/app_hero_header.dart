import 'package:flutter/material.dart';
import '../../core/constants/theme/app_spacing.dart';

/// Reusable Premium Hero Header with Curved Bottom Transition
/// Inspired by high-end wellness & fitness applications.
class AppHeroHeader extends StatelessWidget {
  final Widget? topRow;
  final Widget child;
  final LinearGradient? backgroundGradient;
  final double bottomCurveRadius;
  final EdgeInsetsGeometry padding;

  const AppHeroHeader({
    super.key,
    this.topRow,
    required this.child,
    this.backgroundGradient,
    this.bottomCurveRadius = 32.0,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.xl,
      AppSpacing.lg,
      AppSpacing.xxl,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient ??
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withValues(alpha: 0.18),
                primaryColor.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(bottomCurveRadius),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (topRow != null) ...[
                topRow!,
                const SizedBox(height: AppSpacing.lg),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
