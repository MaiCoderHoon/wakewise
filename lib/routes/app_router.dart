import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/challenges/entities/challenge_difficulty.dart';
import '../domain/entities/alarm.dart';
import '../presentation/screens/add_edit_alarm_screen.dart';
import '../presentation/screens/alarm_ring_screen.dart';
import '../presentation/screens/analytics/analytics_screen.dart';
import '../presentation/screens/challenge/challenge_play_screen.dart';
import '../presentation/screens/challenge/challenge_selection_screen.dart';
import '../presentation/screens/gamification/achievements_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/morning_summary_screen.dart';
import '../presentation/screens/onboarding_screen.dart';
import '../presentation/screens/splash_screen.dart';

/// WakeWise Navigation Router using GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/add-alarm',
      name: 'add-alarm',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AddEditAlarmScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/edit-alarm',
      name: 'edit-alarm',
      pageBuilder: (context, state) {
        final alarm = state.extra as Alarm?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: AddEditAlarmScreen(initialAlarm: alarm),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/challenge-selection',
      name: 'challenge-selection',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ChallengeSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/challenge-play',
      name: 'challenge-play',
      pageBuilder: (context, state) {
        final Map<String, dynamic> extraMap = (state.extra as Map<String, dynamic>?) ?? {};
        final challengeKey = extraMap['challengeKey'] as String? ?? 'math';
        final difficulty = extraMap['difficulty'] as ChallengeDifficulty? ?? ChallengeDifficulty.medium;

        return CustomTransitionPage(
          key: state.pageKey,
          child: ChallengePlayScreen(
            challengeKey: challengeKey,
            difficulty: difficulty,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/alarm-ring',
      name: 'alarm-ring',
      pageBuilder: (context, state) {
        final alarm = (state.extra as Alarm?) ??
            Alarm(
              id: 'demo',
              hour: 7,
              minute: 0,
              label: 'Morning Workout Alarm',
              repeatDays: const [1, 2, 3, 4, 5],
              challengeType: ChallengeType.math,
              enabled: true,
              createdAt: DateTime.now(),
            );

        return CustomTransitionPage(
          key: state.pageKey,
          child: AlarmRingScreen(alarm: alarm),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/analytics',
      name: 'analytics',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AnalyticsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/achievements',
      name: 'achievements',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AchievementsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/morning-summary',
      name: 'morning-summary',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const MorningSummaryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);
