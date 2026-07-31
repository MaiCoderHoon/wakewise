import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_spacing.dart';
import '../../core/constants/theme/app_typography.dart';
import '../../domain/entities/alarm.dart';
import '../blocs/alarm/alarm_bloc.dart';
import '../blocs/alarm/alarm_event.dart';
import '../blocs/alarm/alarm_state.dart';
import '../blocs/stats/stats_bloc.dart';
import '../blocs/stats/stats_state.dart';
import '../widgets/app_card.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/app_primary_button.dart';

/// WakeWise Home Screen UI & Alarm Management Dashboard
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      isScrollable: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-alarm'),
        tooltip: 'Add Alarm',
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Current Date Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Good Morning',
                        style: AppTypography.displayMedium,
                      ),
                      AppSpacing.gapW8,
                      const Text('🌅', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  AppSpacing.gapH4,
                  Text(
                    'Wednesday, July 29',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              // Action Buttons (Analytics & Badges)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.insights_rounded, color: AppColors.secondary, size: 26),
                    tooltip: 'Analytics',
                    onPressed: () => context.push('/analytics'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.emoji_events_rounded, color: AppColors.primaryDark, size: 26),
                    tooltip: 'Achievements',
                    onPressed: () => context.push('/achievements'),
                  ),
                ],
              ),
            ],
          ),

          AppSpacing.gapH24,

          // Real Alarms Dashboard via AlarmBloc
          BlocBuilder<AlarmBloc, AlarmState>(
            builder: (context, state) {
              if (state is AlarmLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.secondary),
                  ),
                );
              }

              if (state is AlarmLoaded) {
                final alarms = state.alarms;
                final upcoming = state.upcomingAlarm;

                if (alarms.isEmpty) {
                  return _EmptyAlarmsState();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Upcoming Alarm Card
                    if (upcoming != null) ...[
                      _HeroUpcomingAlarmCard(alarm: upcoming),
                      AppSpacing.gapH24,
                    ],

                    // Alarms Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Alarms', style: AppTypography.headlineMedium),
                        Text(
                          '${alarms.length} Total',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    AppSpacing.gapH12,

                    // Alarms List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarms[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _AlarmListTile(alarm: alarm),
                        );
                      },
                    ),

                    AppSpacing.gapH24,
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),

          // Today's Mission Card
          const _TodaysMissionCard(),

          AppSpacing.gapH24,

          // Morning Streak Card
          const _MorningStreakCard(),

          AppSpacing.gapH24,

          // Weather Card Placeholder
          const _WeatherCard(),

          AppSpacing.gapH48,
        ],
      ),
    );
  }
}

/// Hero Upcoming Alarm Card
class _HeroUpcomingAlarmCard extends StatelessWidget {
  final Alarm alarm;

  const _HeroUpcomingAlarmCard({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return AppCard.accent(
      onTap: () => context.push('/edit-alarm', extra: alarm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.access_time_filled_rounded, color: AppColors.secondary, size: 20),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(
                        'NEXT UPCOMING ALARM',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.secondaryDark,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: alarm.enabled,
                onChanged: (val) {
                  context.read<AlarmBloc>().add(ToggleAlarm(alarm.id));
                },
                activeTrackColor: AppColors.secondary,
                thumbColor: WidgetStateProperty.all(Colors.white),
              ),
            ],
          ),
          AppSpacing.gapH8,

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                alarm.formattedTime,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapW8,
              Text(
                alarm.formattedPeriod,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.secondaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppSpacing.borderRadiusFull,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    alarm.label,
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.gapH16,
          const Divider(),
          AppSpacing.gapH12,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  alarm.formattedRepeatDays,
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSpacing.gapW8,
              Row(
                children: [
                  Icon(alarm.challengeType.icon, size: 16, color: AppColors.secondary),
                  AppSpacing.gapW4,
                  Text(alarm.challengeType.displayName, style: AppTypography.labelSmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Alarm List Tile Component
class _AlarmListTile extends StatelessWidget {
  final Alarm alarm;

  const _AlarmListTile({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/edit-alarm', extra: alarm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      alarm.formattedTime,
                      style: AppTypography.displaySmall.copyWith(
                        color: alarm.enabled ? AppColors.textPrimary : AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.gapW4,
                    Text(
                      alarm.formattedPeriod,
                      style: AppTypography.titleMedium.copyWith(
                        color: alarm.enabled ? AppColors.secondaryDark : AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.gapW12,
                    Text(
                      alarm.label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: alarm.enabled ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH4,
                Row(
                  children: [
                    Text(
                      alarm.formattedRepeatDays,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                    const Text(' • '),
                    Icon(alarm.challengeType.icon, size: 14, color: AppColors.textMuted),
                    AppSpacing.gapW4,
                    Text(
                      alarm.challengeType.displayName,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: alarm.enabled,
            onChanged: (val) {
              context.read<AlarmBloc>().add(ToggleAlarm(alarm.id));
            },
            activeTrackColor: AppColors.secondary,
            thumbColor: WidgetStateProperty.all(Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Empty State Widget when no alarms are saved
class _EmptyAlarmsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.paddingAllXl,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.alarm_add_rounded, size: 40, color: AppColors.secondary),
            ),
          ),
          AppSpacing.gapH16,
          Text('No Alarms Created Yet', style: AppTypography.headlineSmall),
          AppSpacing.gapH8,
          Text(
            'Set your first sunrise alarm with AI wake-up challenges to start your morning routine.',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH24,
          AppPrimaryButton(
            label: 'Create Your First Alarm',
            icon: Icons.add_rounded,
            onPressed: () => context.push('/add-alarm'),
          ),
        ],
      ),
    );
  }
}

/// Morning Streak & XP Card
class _MorningStreakCard extends StatelessWidget {
  const _MorningStreakCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        int streak = 7;
        int xp = 350;
        int level = 4;

        if (state is StatsLoaded) {
          streak = state.stats.currentStreak > 0 ? state.stats.currentStreak : 1;
          xp = state.stats.totalXp;
          level = state.stats.level;
        }

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: AppColors.secondary, size: 24),
                      AppSpacing.gapW8,
                      Text(
                        'Morning Streak (Lvl $level)',
                        style: AppTypography.titleLarge,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                    child: Text(
                      '$streak DAYS 🔥 • $xp XP',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.secondaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _DayProgressCircle(day: 'Mon', completed: true),
                  _DayProgressCircle(day: 'Tue', completed: true),
                  _DayProgressCircle(day: 'Wed', completed: true, isToday: true),
                  _DayProgressCircle(day: 'Thu', completed: false),
                  _DayProgressCircle(day: 'Fri', completed: false),
                  _DayProgressCircle(day: 'Sat', completed: false),
                  _DayProgressCircle(day: 'Sun', completed: false),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DayProgressCircle extends StatelessWidget {
  final String day;
  final bool completed;
  final bool isToday;

  const _DayProgressCircle({
    required this.day,
    required this.completed,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed
                ? AppColors.primary
                : (isToday ? AppColors.surfaceSubtle : AppColors.surface),
            border: isToday
                ? Border.all(color: AppColors.secondary, width: 2)
                : (completed ? null : Border.all(color: AppColors.border)),
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check_rounded, color: AppColors.textOnPrimary, size: 20)
                : Text(
                    day[0],
                    style: AppTypography.labelSmall.copyWith(
                      color: isToday ? AppColors.secondaryDark : AppColors.textMuted,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
          ),
        ),
        AppSpacing.gapH4,
        Text(
          day,
          style: AppTypography.labelSmall.copyWith(
            color: isToday ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

/// Weather Card Widget Placeholder
class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: AppSpacing.paddingAllMd,
            decoration: BoxDecoration(
              color: AppColors.secondaryLight.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wb_sunny_rounded, color: AppColors.secondary, size: 32),
          ),
          AppSpacing.gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '24°C',
                      style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AppSpacing.gapW8,
                    Text(
                      'Clear Sunrise',
                      style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                AppSpacing.gapH4,
                Text(
                  'Perfect morning light for early wake-up.',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Today's Mission Card
class _TodaysMissionCard extends StatelessWidget {
  const _TodaysMissionCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: AppSpacing.paddingAllMd,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.task_alt_rounded, color: AppColors.primaryDark, size: 28),
          ),
          AppSpacing.gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Mission",
                  style: AppTypography.titleLarge,
                ),
                AppSpacing.gapH4,
                Text(
                  'Math Challenge • 3 Equations',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/challenge-selection'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 38),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: const Text('Test'),
          ),
        ],
      ),
    );
  }
}
