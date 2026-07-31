import 'package:flutter/material.dart';
import '../../../../core/constants/theme/app_colors.dart';
import '../../../../core/constants/theme/app_spacing.dart';
import '../../../../core/constants/theme/app_typography.dart';
import '../../../../domain/entities/morning_mission.dart';

class UpcomingTasksList extends StatelessWidget {
  final MorningMission mission;

  const UpcomingTasksList({
    super.key,
    required this.mission,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'QUEST STAGES',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: mission.tasks.length,
            separatorBuilder: (context, index) => AppSpacing.gapW12,
            itemBuilder: (context, index) {
              final task = mission.tasks[index];
              final isCurrent = index == mission.currentTaskIndex;
              final isCompleted = task.isCompleted || index < mission.currentTaskIndex;

              Color bgColor = AppColors.surface;
              if (isCurrent) {
                bgColor = AppColors.secondary.withValues(alpha: 0.1);
              } else if (isCompleted) {
                bgColor = AppColors.success.withValues(alpha: 0.1);
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 170,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: AppSpacing.borderRadiusSm,
                  border: Border.all(
                    color: isCurrent ? AppColors.secondary : AppColors.border,
                    width: isCurrent ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.success
                            : (isCurrent ? AppColors.secondary : AppColors.border),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCompleted
                            ? Icons.check_rounded
                            : task.challenge.icon,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelMedium.copyWith(
                              color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+${task.xpReward} XP',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.secondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
