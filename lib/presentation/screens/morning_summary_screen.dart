import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/theme/app_spacing.dart';
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
              gradient: LinearGradient(
                colors: [primaryColor, theme.colorScheme.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.wb_sunny_rounded, size: 56, color: Colors.white),
            ),
          ),

          AppSpacing.gapH24,

          Text('Good Morning!', style: theme.textTheme.displayMedium),
          AppSpacing.gapH4,
          Text(
            'Mission completed cleanly. Your brain is wide awake!',
            style: theme.textTheme.bodyLarge,
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
                    Icon(Icons.bolt_rounded, color: primaryColor, size: 28),
                    AppSpacing.gapH4,
                    Text('+$earnedXp XP', style: theme.textTheme.titleLarge),
                    Text('Reward', style: theme.textTheme.bodySmall),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.local_fire_department_rounded, color: primaryColor, size: 28),
                    AppSpacing.gapH4,
                    Text('$streakDays Days', style: theme.textTheme.titleLarge),
                    Text('Streak 🔥', style: theme.textTheme.bodySmall),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.timer_rounded, color: primaryColor, size: 28),
                    AppSpacing.gapH4,
                    Text('${durationSeconds}s', style: theme.textTheme.titleLarge),
                    Text('Wake Time', style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),

          AppSpacing.gapH16,

          // AI Morning Brief Preview Card
          AppCard(
            borderRadius: AppSpacing.radiusLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: primaryColor, size: 20),
                    AppSpacing.gapW8,
                    Text('AI Morning Brief', style: theme.textTheme.titleMedium),
                  ],
                ),
                AppSpacing.gapH8,
                Text(
                  'Today is expected to be sunny and 24°C. You have 3 alarms active for this week. Keep up your awesome morning routine!',
                  style: theme.textTheme.bodySmall,
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
