import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/theme/app_spacing.dart';
import '../../../data/datasources/achievement_local_datasource.dart';
import '../../../domain/entities/achievement.dart';
import '../../blocs/gamification/gamification_bloc.dart';
import '../../blocs/gamification/gamification_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_hero_header.dart';
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AppPageScaffold(
      isScrollable: true,
      padding: EdgeInsets.zero,
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
              AppHeroHeader(
                child: AppCard.accent(
                  child: Row(
                    children: [
                      Container(
                        padding: AppSpacing.paddingAllMd,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.military_tech_rounded, color: primaryColor, size: 36),
                      ),
                      AppSpacing.gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Badge Collection', style: theme.textTheme.headlineMedium),
                            AppSpacing.gapH4,
                            Text(
                              '$unlockedCount of ${achievements.length} Badges Unlocked',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              AppSpacing.gapH24,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('All Achievements', style: theme.textTheme.headlineSmall),
                    AppSpacing.gapH12,

                    Column(
                      children: achievements.map((badge) {
                        final icon = _getIconData(badge.iconName);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: AppCard(
                            padding: AppSpacing.paddingAllMd,
                            borderRadius: AppSpacing.radiusLg,
                            backgroundColor: badge.isUnlocked
                                ? theme.colorScheme.surface
                                : theme.colorScheme.surface.withValues(alpha: 0.5),
                            child: Row(
                              children: [
                                Container(
                                  padding: AppSpacing.paddingAllSm,
                                  decoration: BoxDecoration(
                                    color: badge.isUnlocked
                                        ? primaryColor
                                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    icon,
                                    color: badge.isUnlocked
                                        ? Colors.white
                                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
                                          Expanded(
                                            child: Text(
                                              badge.title,
                                              style: theme.textTheme.titleLarge?.copyWith(
                                                color: badge.isUnlocked
                                                    ? theme.colorScheme.onSurface
                                                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (badge.isUnlocked)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: primaryColor.withValues(alpha: 0.15),
                                                borderRadius: AppSpacing.borderRadiusFull,
                                              ),
                                              child: Text(
                                                'UNLOCKED',
                                                style: theme.textTheme.labelSmall?.copyWith(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      AppSpacing.gapH4,
                                      Text(
                                        badge.description,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: badge.isUnlocked
                                              ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                                              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                        ),
                                      ),
                                      AppSpacing.gapH8,
                                      ClipRRect(
                                        borderRadius: AppSpacing.borderRadiusFull,
                                        child: LinearProgressIndicator(
                                          value: badge.progress,
                                          minHeight: 6,
                                          backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            badge.isUnlocked ? primaryColor : primaryColor.withValues(alpha: 0.4),
                                          ),
                                        ),
                                      ),
                                      AppSpacing.gapH4,
                                      Text(
                                        '${badge.currentValue} / ${badge.requiredValue}',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                        ),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
