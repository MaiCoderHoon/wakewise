import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../core/constants/theme/app_spacing.dart';

/// Data model for quick action item in [AppQuickActionRow]
class QuickActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final String? badgeText;

  const QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.badgeText,
  });
}

/// Floating Quick Action Container Row
/// Inspired by the circular quick action container in the reference design.
class AppQuickActionRow extends StatelessWidget {
  final List<QuickActionItem> items;
  final EdgeInsetsGeometry? margin;

  const AppQuickActionRow({
    super.key,
    required this.items,
    this.margin = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    final glassColor = isDark
        ? primaryColor.withValues(alpha: 0.08)
        : primaryColor.withValues(alpha: 0.06);

    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AdaptiveLiquidGlassLayer(
        child: GlassCard(
          quality: GlassQuality.standard,
          settings: LiquidGlassSettings(
            blur: isDark ? 18 : 14,
            thickness: isDark ? 40 : 28,
            glassColor: glassColor,
            specularSharpness: GlassSpecularSharpness.medium,
          ),
          shape: LiquidRoundedSuperellipse(borderRadius: AppSpacing.radiusXl),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.map((item) {
              final effectiveColor = item.iconColor ?? primaryColor;

              return Flexible(
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: AppSpacing.borderRadiusLg,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                      horizontal: AppSpacing.xs,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: effectiveColor.withValues(alpha: 0.12),
                                border: Border.all(
                                  color: effectiveColor.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: effectiveColor.withValues(alpha: 0.15),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                item.icon,
                                color: effectiveColor,
                                size: 22,
                              ),
                            ),
                            if (item.badgeText != null)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    item.badgeText!,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
