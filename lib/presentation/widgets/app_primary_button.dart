import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_shadows.dart';
import '../../core/constants/theme/app_spacing.dart';
import '../../core/constants/theme/app_typography.dart';

/// WakeWise Reusable Primary Button Component
/// Modern pill-shaped (24-32px radius) button with sunrise aesthetic, glow shadow, haptic feedback and loading state.
class AppPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool fullWidth;
  final double height;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.trailingIcon,
    this.fullWidth = true,
    this.height = 56.0,
    this.gradient,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnim;

  bool get _effectiveDisabled =>
      widget.isDisabled || widget.isLoading || widget.onPressed == null;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: false);
    _shimmerAnim = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_effectiveDisabled) return;
    HapticFeedback.mediumImpact();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = widget.textColor ?? AppColors.textOnPrimary;

    Widget childContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          ),
          AppSpacing.gapW12,
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 20, color: effectiveTextColor),
          AppSpacing.gapW8,
        ],
        Text(
          widget.label,
          style: AppTypography.labelLarge.copyWith(
            color: _effectiveDisabled ? AppColors.textMuted : effectiveTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (!widget.isLoading && widget.trailingIcon != null) ...[
          AppSpacing.gapW8,
          Icon(widget.trailingIcon, size: 20, color: effectiveTextColor),
        ],
      ],
    );

    final buttonDecoration = BoxDecoration(
      color: _effectiveDisabled
          ? AppColors.border
          : (widget.backgroundColor ?? AppColors.primary),
      gradient: _effectiveDisabled ? null : (widget.gradient ?? AppColors.primaryGradient),
      borderRadius: AppSpacing.borderRadiusXl,
      boxShadow: _effectiveDisabled
          ? null
          : (_isPressed ? AppShadows.soft : AppShadows.buttonGlow),
    );

    return AnimatedScale(
      scale: _isPressed && !_effectiveDisabled ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        height: widget.height,
        width: widget.fullWidth ? double.infinity : null,
        decoration: buttonDecoration,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Subtle moving shimmer overlay when active
            if (!_effectiveDisabled)
              AnimatedBuilder(
                animation: _shimmerAnim,
                builder: (context, _) => Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(_shimmerAnim.value - 1, -0.5),
                        end: Alignment(_shimmerAnim.value + 1, 0.5),
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTapDown: _effectiveDisabled ? null : (_) => setState(() => _isPressed = true),
                onTapUp: _effectiveDisabled ? null : (_) => setState(() => _isPressed = false),
                onTapCancel: _effectiveDisabled ? null : () => setState(() => _isPressed = false),
                onTap: _effectiveDisabled ? null : _handleTap,
                borderRadius: AppSpacing.borderRadiusXl,
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
                child: Padding(
                  padding: AppSpacing.paddingHorizLg,
                  child: Center(child: childContent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
