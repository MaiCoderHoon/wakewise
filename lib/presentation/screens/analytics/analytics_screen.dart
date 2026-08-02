import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/theme/app_spacing.dart';
import '../../../domain/entities/user_stats.dart';
import '../../blocs/gamification/gamification_bloc.dart';
import '../../blocs/gamification/gamification_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_hero_header.dart';
import '../../widgets/app_page_scaffold.dart';

/// Analytics Dashboard Screen displaying wake trends, consistency, average delay, and weekly chart
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AppPageScaffold(
      isScrollable: true,
      padding: EdgeInsets.zero,
      appBar: AppBar(
        title: const Text('Analytics & Trends'),
      ),
      body: BlocBuilder<GamificationBloc, GamificationState>(
        builder: (context, state) {
          UserStats stats = const UserStats(
            currentStreak: 7,
            longestStreak: 12,
            totalXp: 450,
            consistencyPercentage: 94.5,
            averageDelaySeconds: 35,
          );

          if (state is GamificationLoaded) {
            stats = state.stats;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Level & XP Progress Card
              AppHeroHeader(
                child: AppCard.accent(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LEVEL ${stats.level} WAKER',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              AppSpacing.gapH4,
                              Text(
                                '${stats.totalXp} Total XP',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: AppSpacing.paddingAllMd,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.bolt_rounded, color: primaryColor, size: 36),
                          ),
                        ],
                      ),
                      AppSpacing.gapH16,
                      ClipRRect(
                        borderRadius: AppSpacing.borderRadiusFull,
                        child: LinearProgressIndicator(
                          value: stats.levelProgress,
                          minHeight: 10,
                          backgroundColor: primaryColor.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                      AppSpacing.gapH8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Level ${stats.level}', style: theme.textTheme.labelSmall),
                          Text(
                            '${((1 - stats.levelProgress) * 100).toInt()} XP to Level ${stats.level + 1}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
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
                    // 2x2 Metric Cards Grid
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            title: 'Current Streak',
                            value: '${stats.currentStreak} Days',
                            icon: Icons.local_fire_department_rounded,
                            iconColor: primaryColor,
                          ),
                        ),
                        AppSpacing.gapW12,
                        Expanded(
                          child: _MetricCard(
                            title: 'Longest Streak',
                            value: '${stats.longestStreak} Days',
                            icon: Icons.emoji_events_rounded,
                            iconColor: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.gapH12,

                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            title: 'Consistency',
                            value: '${stats.consistencyPercentage}%',
                            icon: Icons.trending_up_rounded,
                            iconColor: primaryColor,
                          ),
                        ),
                        AppSpacing.gapW12,
                        Expanded(
                          child: _MetricCard(
                            title: 'Avg Wake Delay',
                            value: '${stats.averageDelaySeconds}s',
                            icon: Icons.timer_rounded,
                            iconColor: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.gapH24,

                    // Weekly Completion Bar Chart
                    Text('Weekly Morning Consistency', style: theme.textTheme.headlineSmall),
                    AppSpacing.gapH12,

                    AppCard(
                      padding: AppSpacing.paddingAllLg,
                      borderRadius: AppSpacing.radiusLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Wake Duration (Sec)', style: theme.textTheme.titleMedium),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.12),
                                  borderRadius: AppSpacing.borderRadiusFull,
                                ),
                                child: Text(
                                  'This Week',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapH24,
                          SizedBox(
                            height: 180,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 60,
                                barTouchData: BarTouchData(enabled: true),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (val, meta) {
                                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                        if (val.toInt() >= 0 && val.toInt() < days.length) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              days[val.toInt()],
                                              style: theme.textTheme.labelSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                barGroups: [
                                  _makeBarGroup(context, 0, 30),
                                  _makeBarGroup(context, 1, 45),
                                  _makeBarGroup(context, 2, 25),
                                  _makeBarGroup(context, 3, 40),
                                  _makeBarGroup(context, 4, 20),
                                  _makeBarGroup(context, 5, 35),
                                  _makeBarGroup(context, 6, 15, isToday: true),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

  BarChartGroupData _makeBarGroup(BuildContext context, int x, double y, {bool isToday = false}) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isToday ? primaryColor : primaryColor.withValues(alpha: 0.35),
          width: 18,
          borderRadius: AppSpacing.borderRadiusSm,
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: AppSpacing.paddingAllMd,
      borderRadius: AppSpacing.radiusLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              AppSpacing.gapW8,
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSpacing.gapH8,
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
