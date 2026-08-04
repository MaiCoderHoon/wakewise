import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../core/constants/theme/app_spacing.dart';
import '../../domain/entities/alarm.dart';
import '../blocs/alarm/alarm_bloc.dart';
import '../blocs/alarm/alarm_event.dart';
import '../blocs/alarm/alarm_state.dart';
import '../blocs/stats/stats_bloc.dart';
import '../blocs/stats/stats_state.dart';
import '../widgets/app_card.dart';
import '../widgets/app_hero_header.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/app_quick_action_row.dart';

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
    if (hour >= 12 && hour < 17) return ('Good Afternoon', '☀️');
    if (hour >= 17 && hour < 21) return ('Good Evening', '🌇');
    return ('Good Night', '🌙');
  }

  String _formattedDate(DateTime now) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final (greetingText, emoji) = _getGreetingInfo(now);
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AppPageScaffold(
      isScrollable: true,
      padding: EdgeInsets.zero,
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
          // ── Curved Hero Header ──────────────────────────────────────────
          AppHeroHeader(
            topRow: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          greetingText,
                          style: theme.textTheme.displayMedium,
                        ),
                        AppSpacing.gapW8,
                        Text(emoji, style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                    AppSpacing.gapH4,
                    Text(
                      _formattedDate(now),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                // Action Buttons (Analytics & Achievements)
                Row(
                  children: [
                    _HeaderIconButton(
                      icon: Icons.insights_rounded,
                      color: primaryColor,
                      tooltip: 'Analytics',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.push('/analytics');
                      },
                    ),
                    AppSpacing.gapW8,
                    _HeaderIconButton(
                      icon: Icons.emoji_events_rounded,
                      color: theme.colorScheme.secondary,
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
            child: BlocBuilder<AlarmBloc, AlarmState>(
              builder: (context, state) {
                Alarm? upcoming;
                if (state is AlarmLoaded) {
                  upcoming = state.upcomingAlarm;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEXT ALARM',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    AppSpacing.gapH4,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          upcoming != null ? upcoming.formattedTime : '--:--',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                          ),
                        ),
                        AppSpacing.gapW8,
                        Text(
                          upcoming != null ? upcoming.formattedPeriod : '',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          AppSpacing.gapH16,

          // ── Floating Quick Actions Row ─────────────────────────────────
          AppQuickActionRow(
            items: [
              QuickActionItem(
                icon: Icons.add_alarm_rounded,
                label: 'Add Alarm',
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/add-alarm');
                },
              ),
              QuickActionItem(
                icon: Icons.wb_sunny_rounded,
                label: 'Quest',
                badgeText: 'HOT',
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/morning-quest');
                },
              ),
              QuickActionItem(
                icon: Icons.sports_esports_rounded,
                label: 'Challenges',
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/challenge-selection');
                },
              ),
              QuickActionItem(
                icon: Icons.insights_rounded,
                label: 'Stats',
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/analytics');
                },
              ),
            ],
          ),

          AppSpacing.gapH24,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Real Alarms Dashboard via AlarmBloc ─────────────────
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
                              Text(
                                'Your Alarms',
                                style: theme.textTheme.headlineMedium,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.12),
                                  borderRadius: AppSpacing.borderRadiusFull,
                                ),
                                child: Text(
                                  '${alarms.length} Total',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: primaryColor,
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
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
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
          ),
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
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
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
    return const Column(
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
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

/// Hero Upcoming Alarm Card
class _HeroUpcomingAlarmCard extends StatefulWidget {
  final Alarm alarm;

  const _HeroUpcomingAlarmCard({required this.alarm});

  @override
  State<_HeroUpcomingAlarmCard> createState() => _HeroUpcomingAlarmCardState();
}

class _HeroUpcomingAlarmCardState extends State<_HeroUpcomingAlarmCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _glowAnim = CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarm = widget.alarm;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    // Glass surface colours adapt to the current theme
    final glassColor = isDark
        ? primaryColor.withValues(alpha: 0.08)
        : primaryColor.withValues(alpha: 0.06);

    return GestureDetector(
      onTap: () => context.push('/edit-alarm', extra: alarm),
      child: AdaptiveLiquidGlassLayer(
        child: GlassCard(
          quality: GlassQuality.standard,
          settings: LiquidGlassSettings(
            blur: isDark ? 18 : 14,
            thickness: isDark ? 40 : 28,
            glassColor: glassColor,
            specularSharpness: GlassSpecularSharpness.medium,
          ),
          shape: LiquidRoundedSuperellipse(borderRadius: AppSpacing.radiusLg),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Stack(
            children: [
              // Subtle radial highlight behind the time for depth
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: AppSpacing.borderRadiusXl,
                      gradient: RadialGradient(
                        center: const Alignment(-0.6, -0.2),
                        radius: 0.95,
                        colors: [
                          primaryColor.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar: Header label & Visually secondary toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // ── Glowing Clock Icon ──────────────────────────
                          AnimatedBuilder(
                            animation: _glowAnim,
                            builder: (context, _) {
                              final t = _glowAnim.value;
                              // Background alpha: 0.10 → 0.22
                              final bgAlpha = 0.10 + t * 0.12;
                              // Glow blur: 4 → 9px  (tight, stays close to icon)
                              final glowBlur = 4.0 + t * 5.0;
                              // Glow spread: 0 → 1.5px  (minimal outward push)
                              final glowSpread = t * 1.5;
                              // Glow opacity: 0.25 → 0.65
                              final glowOpacity = 0.25 + t * 0.40;

                              return Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(
                                    alpha: bgAlpha,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: glowOpacity,
                                      ),
                                      blurRadius: glowBlur,
                                      spreadRadius: glowSpread,
                                    ),
                                    // Inner soft halo
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: glowOpacity * 0.2,
                                      ),
                                      blurRadius: glowBlur * 1.2,
                                      spreadRadius: glowSpread * 0.4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.access_time_filled_rounded,
                                  color: primaryColor,
                                  size: 16,
                                ),
                              );
                            },
                          ),
                          AppSpacing.gapW8,
                          Text(
                            'NEXT UPCOMING ALARM',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Transform.scale(
                        scale: 0.85,
                        child: Switch.adaptive(
                          value: alarm.enabled,
                          onChanged: (val) {
                            HapticFeedback.selectionClick();
                            context.read<AlarmBloc>().add(
                              ToggleAlarm(alarm.id),
                            );
                          },
                          activeTrackColor: primaryColor,
                          thumbColor: WidgetStateProperty.all(Colors.white),
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.gapH8,

                  // Dominant Alarm Time Display
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        alarm.formattedTime,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          letterSpacing: -2.0,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      AppSpacing.gapW8,
                      Text(
                        alarm.formattedPeriod,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 26,
                          color: primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.gapH4,

                  // Alarm Label directly beneath time
                  Row(
                    children: [
                      Icon(
                        Icons.label_outline_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      AppSpacing.gapW4,
                      Expanded(
                        child: Text(
                          alarm.label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.85,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.gapH16,

                  // Subtle separator line with reduced visual weight
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.outline.withValues(alpha: 0.12),
                  ),

                  AppSpacing.gapH12,

                  // Improved Metadata Row (Weekdays & Challenge)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            AppSpacing.gapW4,
                            Expanded(
                              child: Text(
                                alarm.formattedRepeatDays,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.gapW12,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: AppSpacing.borderRadiusFull,
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              alarm.challengeType.icon,
                              size: 14,
                              color: primaryColor,
                            ),
                            AppSpacing.gapW4,
                            Text(
                              alarm.challengeType.displayName,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: alarm.enabled
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AppSpacing.gapW4,
                        Text(
                          alarm.formattedPeriod,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: alarm.enabled
                                ? primaryColor
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: Text(
                        alarm.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: alarm.enabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    const Text(' • '),
                    Icon(
                      alarm.challengeType.icon,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    AppSpacing.gapW4,
                    Text(
                      alarm.challengeType.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
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
            activeTrackColor: primaryColor,
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AppCard(
      padding: AppSpacing.paddingAllXl,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, theme.colorScheme.secondary],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.alarm_add_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('No Alarms Created Yet', style: theme.textTheme.headlineSmall),
          AppSpacing.gapH8,
          Text(
            'Set your first sunrise alarm with wake-up challenges to build your morning routine.',
            style: theme.textTheme.bodyMedium,
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        int streak = 7;
        int xp = 350;
        int level = 4;

        if (state is StatsLoaded) {
          streak = state.stats.currentStreak > 0
              ? state.stats.currentStreak
              : 1;
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
                      Icon(
                        Icons.local_fire_department_rounded,
                        color: primaryColor,
                        size: 24,
                      ),
                      AppSpacing.gapW8,
                      Text(
                        'Morning Streak (Lvl $level)',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                    child: Text(
                      '$streak DAYS 🔥 • $xp XP',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH16,
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _DayProgressCircle(day: 'Mon', completed: true, index: 0),
                  _DayProgressCircle(day: 'Tue', completed: true, index: 1),
                  _DayProgressCircle(
                    day: 'Wed',
                    completed: true,
                    isToday: true,
                    index: 2,
                  ),
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed
                ? primaryColor
                : (isToday
                      ? primaryColor.withValues(alpha: 0.15)
                      : theme.colorScheme.surface),
            border: isToday
                ? Border.all(color: primaryColor, width: 2)
                : (completed
                      ? null
                      : Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.4,
                          ),
                        )),
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : Text(
                    day[0],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isToday
                          ? primaryColor
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
          ),
        ),
        AppSpacing.gapH4,
        Text(
          day,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isToday
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AppCard(
      child: Row(
        children: [
          Container(
            padding: AppSpacing.paddingAllMd,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.wb_sunny_rounded, color: primaryColor, size: 32),
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
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.gapW8,
                    Text(
                      'Clear Sunrise',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH4,
                Text(
                  'Perfect morning light for early wake-up.',
                  style: theme.textTheme.bodySmall,
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AppCard(
      child: Row(
        children: [
          Container(
            padding: AppSpacing.paddingAllMd,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.task_alt_rounded, color: primaryColor, size: 28),
          ),
          AppSpacing.gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Mission", style: theme.textTheme.titleLarge),
                AppSpacing.gapH4,
                Text(
                  'Math Challenge • 3 Equations',
                  style: theme.textTheme.bodySmall,
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
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
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
