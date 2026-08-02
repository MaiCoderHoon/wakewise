import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_shadows.dart';
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
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  (String greeting, String emoji) _getGreetingInfo(DateTime now) {
    final hour = now.hour;
    if (hour >= 5 && hour < 12) return ('Good Morning', '🌅');
    if (hour >= 12 && hour < 17) return ('Good Afternoon', '🌤️');
    if (hour >= 17 && hour < 21) return ('Good Evening', '🌇');
    return ('Good Night', '🌙');
  }

  String _formattedDate(DateTime now) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final (greetingText, emoji) = _getGreetingInfo(now);

    return AppPageScaffold(
      isScrollable: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          context.push('/add-alarm');
        },
        tooltip: 'Add Alarm',
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting & Current Date Header ─────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        greetingText,
                        style: AppTypography.displayMedium,
                      ),
                      AppSpacing.gapW8,
                      Text(emoji, style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                  AppSpacing.gapH4,
                  Text(
                    _formattedDate(now),
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              // Action Buttons (Analytics & Achievements)
              Row(
                children: [
                  _HeaderIconButton(
                    icon: Icons.insights_rounded,
                    color: AppColors.secondary,
                    tooltip: 'Analytics',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.push('/analytics');
                    },
                  ),
                  AppSpacing.gapW8,
                  _HeaderIconButton(
                    icon: Icons.emoji_events_rounded,
                    color: AppColors.primaryDark,
                    tooltip: 'Achievements',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.push('/achievements');
                    },
                  ),
                ],
              ),
            ],
          ),

          AppSpacing.gapH24,

          // ── Morning Quest Banner ───────────────────────────────────────
          AppCard.primary(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 26),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🌅 Morning Quest',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Conquer Math, Memory & Shake challenges!',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapW8,
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/morning-quest');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.secondary,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    elevation: 0,
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          AppSpacing.gapH24,

          // ── Real Alarms Dashboard via AlarmBloc ─────────────────────────
          BlocBuilder<AlarmBloc, AlarmState>(
            builder: (context, state) {
              if (state is AlarmLoading) {
                return const _AlarmsLoadingShimmer();
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: AppSpacing.borderRadiusFull,
                          ),
                          child: Text(
                            '${alarms.length} Total',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

/// Header Icon Pill Action Button
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.soft,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

/// Shimmer Skeleton Loading Placeholder for Alarms
class _AlarmsLoadingShimmer extends StatelessWidget {
  const _AlarmsLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ShimmerTile(height: 140),
        AppSpacing.gapH12,
        _ShimmerTile(height: 80),
        AppSpacing.gapH12,
        _ShimmerTile(height: 80),
      ],
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  final double height;
  const _ShimmerTile({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle.withValues(alpha: 0.6),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.border),
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
                  HapticFeedback.selectionClick();
                  context.read<AlarmBloc>().add(ToggleAlarm(alarm.id));
                },
                activeTrackColor: AppColors.secondary,
                thumbColor: WidgetStateProperty.all(Colors.white),
              ),
            ],
          ),
          AppSpacing.gapH8,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                ],
              ),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      ],
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: Text(
                        alarm.label,
                        style: AppTypography.bodyMedium.copyWith(
                          color: alarm.enabled ? AppColors.textPrimary : AppColors.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
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
              HapticFeedback.selectionClick();
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
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft,
            ),
            child: const Center(
              child: Icon(Icons.alarm_add_rounded, size: 42, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text('No Alarms Created Yet', style: AppTypography.headlineSmall),
          AppSpacing.gapH8,
          Text(
            'Set your first sunrise alarm with wake-up challenges to build your morning routine.',
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
                  _DayProgressCircle(day: 'Mon', completed: true, index: 0),
                  _DayProgressCircle(day: 'Tue', completed: true, index: 1),
                  _DayProgressCircle(day: 'Wed', completed: true, isToday: true, index: 2),
                  _DayProgressCircle(day: 'Thu', completed: false, index: 3),
                  _DayProgressCircle(day: 'Fri', completed: false, index: 4),
                  _DayProgressCircle(day: 'Sat', completed: false, index: 5),
                  _DayProgressCircle(day: 'Sun', completed: false, index: 6),
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
  final int index;

  const _DayProgressCircle({
    required this.day,
    required this.completed,
    this.isToday = false,
    this.index = 0,
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
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/challenge-selection');
            },
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
