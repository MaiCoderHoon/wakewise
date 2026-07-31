import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_shadows.dart';
import '../../core/constants/theme/app_spacing.dart';
import '../../core/constants/theme/app_typography.dart';
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
    final formattedHour = _currentTime.hour % 12 == 0 ? 12 : _currentTime.hour % 12;
    final formattedMinute = _currentTime.minute.toString().padLeft(2, '0');
    final period = _currentTime.hour >= 12 ? 'PM' : 'AM';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
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
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wb_sunny_rounded, color: AppColors.secondary, size: 18),
                          AppSpacing.gapW8,
                          Text(
                            'WAKEWISE SUNRISE ALARM',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.secondaryDark,
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
                      style: AppTypography.headlineLarge,
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
                    gradient: AppColors.primaryGradient,
                    boxShadow: AppShadows.floating,
                  ),
                  child: Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
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
                                style: AppTypography.displayLarge.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.gapW4,
                              Text(
                                period,
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.secondaryDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapH8,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(widget.alarm.challengeType.icon, size: 16, color: AppColors.secondary),
                              AppSpacing.gapW4,
                              Text(
                                widget.alarm.challengeType.displayName,
                                style: AppTypography.labelSmall,
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
                      color: AppColors.surface,
                      borderRadius: AppSpacing.borderRadiusXl,
                      boxShadow: AppShadows.buttonGlow,
                      border: Border.all(color: AppColors.primaryLight, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.keyboard_double_arrow_up_rounded,
                          color: AppColors.secondary,
                          size: 32,
                        ),
                        AppSpacing.gapH4,
                        Text(
                          'SWIPE UP TO BEGIN MISSION',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textPrimary,
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
