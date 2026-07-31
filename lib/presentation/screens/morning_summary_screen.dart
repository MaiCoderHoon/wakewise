import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_shadows.dart';
import '../../core/constants/theme/app_spacing.dart';
import '../../core/constants/theme/app_typography.dart';
import '../widgets/app_card.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/app_primary_button.dart';

/// Post-challenge Morning Summary Screen shown after completing a wake-up mission
class MorningSummaryScreen extends StatelessWidget {
  final int earnedXp;
  final int streakDays;
  final int durationSeconds;

  const MorningSummaryScreen({
    super.key,
    this.earnedXp = 25,
    this.streakDays = 7,
    this.durationSeconds = 35,
  });

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      isScrollable: true,
      appBar: AppBar(
        title: const Text('Morning Summary'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Celebration Sunrise Icon
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: AppShadows.floating,
            ),
            child: const Center(
              child: Icon(Icons.wb_sunny_rounded, size: 56, color: AppColors.textOnPrimary),
            ),
          ),

          AppSpacing.gapH24,

          Text('Good Morning!', style: AppTypography.displayMedium),
          AppSpacing.gapH4,
          Text(
            'Mission completed cleanly. Your brain is wide awake!',
            style: AppTypography.bodyLarge,
            textAlign: TextAlign.center,
          ),

          AppSpacing.gapH24,

          // Rewards Summary Card
          AppCard.accent(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.secondary, size: 28),
                    AppSpacing.gapH4,
                    Text('+$earnedXp XP', style: AppTypography.titleLarge),
                    Text('Reward', style: AppTypography.bodySmall),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: AppColors.secondary, size: 28),
                    AppSpacing.gapH4,
                    Text('$streakDays Days', style: AppTypography.titleLarge),
                    Text('Streak 🔥', style: AppTypography.bodySmall),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.timer_rounded, color: AppColors.secondaryDark, size: 28),
                    AppSpacing.gapH4,
                    Text('${durationSeconds}s', style: AppTypography.titleLarge),
                    Text('Wake Time', style: AppTypography.bodySmall),
                  ],
                ),
              ],
            ),
          ),

          AppSpacing.gapH16,

          // AI Morning Brief Preview Card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppColors.secondary, size: 20),
                    AppSpacing.gapW8,
                    Text('AI Morning Brief', style: AppTypography.titleMedium),
                  ],
                ),
                AppSpacing.gapH8,
                Text(
                  'Today is expected to be sunny and 24°C. You have 3 alarms active for this week. Keep up your awesome morning routine!',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),

          AppSpacing.gapH32,

          AppPrimaryButton(
            label: 'Start Your Day 🚀',
            icon: Icons.check_rounded,
            onPressed: () => context.go('/home'),
          ),

          AppSpacing.gapH32,
        ],
      ),
    );
  }
}
