import 'package:flutter/material.dart';

/// WakeWise centralized animation constants, curves, and utilities.
abstract class AppAnimations {
  // ── Durations ───────────────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 900);

  // ── Curves ──────────────────────────────────────────────────────
  static const Curve bounce = Curves.elasticOut;
  static const Curve decelerate = Curves.decelerate;
  static const Curve emphasize = Curves.easeInOutCubic;
  static const Curve enterCurve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;

  // ── Stagger helpers ─────────────────────────────────────────────
  static Duration stagger(int index, {int msPerItem = 60}) =>
      Duration(milliseconds: index * msPerItem);

  // ── Time-of-day dynamic gradient ────────────────────────────────
  /// Returns a sunrise/day/dusk/night gradient based on the current hour.
  static LinearGradient getTimeOfDayGradient([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;

    // Sunrise: 5–8
    if (hour >= 5 && hour < 8) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFE0A3), Color(0xFFFF8C42), Color(0xFFFFF8EE)],
        stops: [0.0, 0.45, 1.0],
      );
    }
    // Morning: 8–12
    if (hour >= 8 && hour < 12) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF3CD), Color(0xFFFFF8EE)],
      );
    }
    // Afternoon: 12–17
    if (hour >= 12 && hour < 17) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF8EE), Color(0xFFFFF3E0)],
      );
    }
    // Dusk: 17–20
    if (hour >= 17 && hour < 20) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFB380), Color(0xFFFF6B35), Color(0xFFB5341C)],
        stops: [0.0, 0.5, 1.0],
      );
    }
    // Night: 20–5
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A1035), Color(0xFF2D1B69), Color(0xFF11082B)],
      stops: [0.0, 0.5, 1.0],
    );
  }

  /// Returns true when the hour is in the night range (needs light text)
  static bool isNightTime([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    return hour >= 20 || hour < 5;
  }

  /// Returns true when the hour is dusk (needs medium-contrast text)
  static bool isDuskTime([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    return hour >= 17 && hour < 20;
  }

  /// Greeting text and emoji for the current hour
  static ({String greeting, String emoji}) getGreeting([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 12) return (greeting: 'Good Morning', emoji: '🌅');
    if (hour >= 12 && hour < 17) return (greeting: 'Good Afternoon', emoji: '🌤️');
    if (hour >= 17 && hour < 21) return (greeting: 'Good Evening', emoji: '🌇');
    return (greeting: 'Good Night', emoji: '🌙');
  }
}
