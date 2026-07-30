import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/entities/alarm.dart';
import '../presentation/screens/add_edit_alarm_screen.dart';
import '../presentation/screens/home_screen.dart';
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
  ],
);
