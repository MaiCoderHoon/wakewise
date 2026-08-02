import 'package:flutter/material.dart';
import '../../../../core/constants/theme/app_animations.dart';
import '../../../../core/constants/theme/app_colors.dart';
import '../../../../core/constants/theme/app_spacing.dart';
import '../../../../core/constants/theme/app_typography.dart';
import '../../../../domain/entities/morning_mission.dart';

/// Progress header for the Mission screen with animated progress bar
class MissionProgressHeader extends StatelessWidget {
  final MorningMission mission;

  const MissionProgressHeader({
    super.key,
    required this.mission,
  });

  @override
  Widget build(BuildContext context) {
    final currentStep = mission.currentTaskIndex + 1;
    final totalSteps = mission.tasks.length;
    final progress = mission.progress;

    return Container(
      padding: AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🌅 Morning Quest',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Stage $currentStep of $totalSteps',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapW8,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '+${mission.totalXpReward} XP',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapH16,
          // Animated progress bar that tweens on value change
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress),
            duration: AppAnimations.standard,
            curve: AppAnimations.decelerate,
            builder: (context, value, _) => ClipRRect(
              borderRadius: AppSpacing.borderRadiusFull,
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: AppColors.surfaceSubtle,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
