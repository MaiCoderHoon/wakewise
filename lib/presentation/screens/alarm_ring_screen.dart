import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/theme/app_spacing.dart';
import '../../domain/challenges/entities/challenge_difficulty.dart';
import '../../domain/entities/alarm.dart';
import '../../domain/entities/alarm_history.dart';
import '../blocs/gamification/gamification_bloc.dart';
import '../blocs/gamification/gamification_event.dart';
import '../blocs/stats/stats_bloc.dart';
import '../blocs/stats/stats_event.dart';

/// Full-screen Alarm Ring Screen with animated sunrise halo and swipe-up gesture
class AlarmRingScreen extends StatefulWidget {
  final Alarm alarm;

  const AlarmRingScreen({
    super.key,
    required this.alarm,
  });

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _haloController;
  late Animation<double> _haloScaleAnimation;
  late Timer _clockTimer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();

    // Clock ticker updating every second
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _currentTime = DateTime.now());
      }
    });

    // Pulsing sunrise halo animation
    _haloController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _haloScaleAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _haloController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _haloController.dispose();
    super.dispose();
  }

  Future<void> _startMission() async {
    final startTime = DateTime.now();

    final result = await context.push<bool>(
      '/challenge-play',
      extra: {
        'challengeKey': widget.alarm.challengeType.name,
        'difficulty': ChallengeDifficulty.medium,
      },
    );

    if (result == true && mounted) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inSeconds;

      final historyEntry = AlarmHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        alarmId: widget.alarm.id,
        alarmLabel: widget.alarm.label,
        completedAt: endTime,
        challengeType: widget.alarm.challengeType,
        earnedXp: widget.alarm.challengeType.displayName == 'Standard Alarm' ? 10 : 25,
        durationSeconds: duration,
      );

      context.read<StatsBloc>().add(RecordWakeUp(historyEntry));
      context.read<GamificationBloc>().add(EvaluateGamificationOnWake(historyEntry));

      context.go('/morning-summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final formattedHour = _currentTime.hour % 12 == 0 ? 12 : _currentTime.hour % 12;
    final formattedMinute = _currentTime.minute.toString().padLeft(2, '0');
    final period = _currentTime.hour >= 12 ? 'PM' : 'AM';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withValues(alpha: 0.25),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Header
              Padding(
                padding: AppSpacing.paddingAllLg,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wb_sunny_rounded, color: primaryColor, size: 18),
                          AppSpacing.gapW8,
                          Text(
                            'WAKEWISE SUNRISE ALARM',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.gapH12,
                    Text(
                      widget.alarm.label,
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Animated Pulsing Sunrise Halo + Digital Clock
              ScaleTransition(
                scale: _haloScaleAnimation,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [primaryColor, theme.colorScheme.secondary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.4),
                        blurRadius: 32,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.surface,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${formattedHour.toString().padLeft(2, '0')}:$formattedMinute',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              AppSpacing.gapW4,
                              Text(
                                period,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapH8,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(widget.alarm.challengeType.icon, size: 16, color: primaryColor),
                              AppSpacing.gapW4,
                              Text(
                                widget.alarm.challengeType.displayName,
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Interactive Swipe-Up Gesture Area
              Padding(
                padding: AppSpacing.pagePadding,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity != null && details.primaryVelocity! < -200) {
                      _startMission();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: AppSpacing.borderRadiusXl,
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.keyboard_double_arrow_up_rounded,
                          color: primaryColor,
                          size: 32,
                        ),
                        AppSpacing.gapH4,
                        Text(
                          'SWIPE UP TO BEGIN MISSION',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
