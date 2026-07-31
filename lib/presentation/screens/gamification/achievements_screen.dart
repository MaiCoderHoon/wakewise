import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/theme/app_colors.dart';
import '../../../core/constants/theme/app_shadows.dart';
import '../../../core/constants/theme/app_spacing.dart';
import '../../../core/constants/theme/app_typography.dart';
import '../../../data/datasources/achievement_local_datasource.dart';
import '../../../domain/entities/achievement.dart';
import '../../blocs/gamification/gamification_bloc.dart';
import '../../blocs/gamification/gamification_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_page_scaffold.dart';

/// Screen displaying locked and unlocked achievements & badges
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wb_sunny_rounded':
        return Icons.wb_sunny_rounded;
      case 'local_fire_department_rounded':
        return Icons.local_fire_department_rounded;
      case 'workspace_premium_rounded':
        return Icons.workspace_premium_rounded;
      case 'bolt_rounded':
        return Icons.bolt_rounded;
      case 'calculate_rounded':
        return Icons.calculate_rounded;
      case 'vibration_rounded':
        return Icons.vibration_rounded;
      default:
        return Icons.emoji_events_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      isScrollable: true,
      appBar: AppBar(
        title: const Text('Achievements & Badges'),
      ),
      body: BlocBuilder<GamificationBloc, GamificationState>(
        builder: (context, state) {
          List<Achievement> achievements = AchievementLocalDataSourceImpl.defaultAchievements;

          if (state is GamificationLoaded && state.achievements.isNotEmpty) {
            achievements = state.achievements;
          }

          final unlockedCount = achievements.where((a) => a.isUnlocked).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Summary Card
              AppCard.accent(
                child: Row(
                  children: [
                    Container(
                      padding: AppSpacing.paddingAllMd,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.soft,
                      ),
                      child: const Icon(Icons.military_tech_rounded, color: AppColors.secondary, size: 36),
                    ),
                    AppSpacing.gapW16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Badge Collection', style: AppTypography.headlineMedium),
                          AppSpacing.gapH4,
                          Text(
                            '$unlockedCount of ${achievements.length} Badges Unlocked',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.secondaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.gapH24,

              Text('All Achievements', style: AppTypography.headlineSmall),
              AppSpacing.gapH12,

              Column(
                children: achievements.map((badge) {
                  final icon = _getIconData(badge.iconName);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AppCard(
                      padding: AppSpacing.paddingAllMd,
                      backgroundColor: badge.isUnlocked ? AppColors.surface : AppColors.surfaceSubtle.withValues(alpha: 0.5),
                      child: Row(
                        children: [
                          Container(
                            padding: AppSpacing.paddingAllSm,
                            decoration: BoxDecoration(
                              color: badge.isUnlocked ? AppColors.primary : AppColors.border,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: badge.isUnlocked ? AppColors.textOnPrimary : AppColors.textMuted,
                              size: 28,
                            ),
                          ),
                          AppSpacing.gapW16,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      badge.title,
                                      style: AppTypography.titleLarge.copyWith(
                                        color: badge.isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                                      ),
                                    ),
                                    if (badge.isUnlocked)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(alpha: 0.15),
                                          borderRadius: AppSpacing.borderRadiusFull,
                                        ),
                                        child: Text(
                                          'UNLOCKED',
                                          style: AppTypography.labelSmall.copyWith(
                                            color: AppColors.success,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                AppSpacing.gapH4,
                                Text(
                                  badge.description,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: badge.isUnlocked ? AppColors.textSecondary : AppColors.textMuted,
                                  ),
                                ),
                                AppSpacing.gapH8,
                                ClipRRect(
                                  borderRadius: AppSpacing.borderRadiusFull,
                                  child: LinearProgressIndicator(
                                    value: badge.progress,
                                    minHeight: 6,
                                    backgroundColor: AppColors.border,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      badge.isUnlocked ? AppColors.secondary : AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                AppSpacing.gapH4,
                                Text(
                                  '${badge.currentValue} / ${badge.requiredValue}',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              AppSpacing.gapH32,
            ],
          );
        },
      ),
    );
  }
}
