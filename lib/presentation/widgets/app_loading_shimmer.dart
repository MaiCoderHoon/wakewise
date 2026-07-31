import 'package:flutter/material.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_spacing.dart';


/// Warm-toned shimmer skeleton for loading states.
/// Replaces plain CircularProgressIndicator while data is loading.
class AppShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppShimmerBox({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = AppSpacing.radiusSm,
  });

  @override
  State<AppShimmerBox> createState() => _AppShimmerBoxState();
}

class _AppShimmerBoxState extends State<AppShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shimmer = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + _shimmer.value * 0.5, 0),
              end: Alignment(1.5 + _shimmer.value * 0.5, 0),
              colors: const [
                Color(0xFFF5EDD8),
                Color(0xFFFFF3E0),
                Color(0xFFFFE0A3),
                Color(0xFFFFF3E0),
                Color(0xFFF5EDD8),
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Pre-composed shimmer skeleton for an alarm list tile
class AlarmTileShimmer extends StatelessWidget {
  const AlarmTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppShimmerBox(width: 120, height: 28, borderRadius: 8),
                AppSpacing.gapH8,
                const AppShimmerBox(width: 180, height: 14, borderRadius: 6),
              ],
            ),
          ),
          AppSpacing.gapW16,
          const AppShimmerBox(width: 52, height: 32, borderRadius: 16),
        ],
      ),
    );
  }
}

/// Pre-composed shimmer skeleton for a stat/metric card
class MetricCardShimmer extends StatelessWidget {
  const MetricCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppShimmerBox(width: 80, height: 12, borderRadius: 6),
          AppSpacing.gapH8,
          const AppShimmerBox(width: 120, height: 22, borderRadius: 8),
        ],
      ),
    );
  }
}
