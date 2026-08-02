import 'dart:async';
import 'package:flutter/material.dart';
import '../services/time_of_day_service.dart';
import 'afternoon_theme.dart';
import 'evening_theme.dart';
import 'morning_theme.dart';
import 'night_theme.dart';

/// Central theme manager that manages and exposes the active [WakeTheme] and corresponding [ThemeData].
///
/// Efficiently listens to app lifecycle state (resumed) and schedules exact time-boundary timers
/// without continuous polling.
class DynamicThemeManager extends ChangeNotifier with WidgetsBindingObserver {
  final TimeOfDayService _timeOfDayService;
  late WakeTheme _currentTheme;
  Timer? _boundaryTimer;

  DynamicThemeManager({TimeOfDayService? timeOfDayService})
      : _timeOfDayService = timeOfDayService ?? const TimeOfDayService() {
    WidgetsBinding.instance.addObserver(this);
    _evaluateAndSetTheme();
  }

  /// Current active [WakeTheme]
  WakeTheme get currentTheme => _currentTheme;

  /// Exposes the active [ThemeData] for the current time phase
  ThemeData get currentThemeData {
    switch (_currentTheme) {
      case WakeTheme.morning:
        return buildMorningTheme();
      case WakeTheme.afternoon:
        return buildAfternoonTheme();
      case WakeTheme.evening:
        return buildEveningTheme();
      case WakeTheme.night:
        return buildNightTheme();
    }
  }

  /// Exposes the background [LinearGradient] for the current time phase
  LinearGradient get currentGradient {
    switch (_currentTheme) {
      case WakeTheme.morning:
        return morningGradient;
      case WakeTheme.afternoon:
        return afternoonGradient;
      case WakeTheme.evening:
        return eveningGradient;
      case WakeTheme.night:
        return nightGradient;
    }
  }

  /// Exposes the card accent [LinearGradient] for the current time phase
  LinearGradient get cardGradient {
    switch (_currentTheme) {
      case WakeTheme.morning:
        return morningCardGradient;
      case WakeTheme.afternoon:
        return afternoonCardGradient;
      case WakeTheme.evening:
        return eveningCardGradient;
      case WakeTheme.night:
        return nightCardGradient;
    }
  }

  /// Exposes the time-contextual greeting text (e.g. "Good Morning")
  String get greeting {
    switch (_currentTheme) {
      case WakeTheme.morning:
        return 'Good Morning';
      case WakeTheme.afternoon:
        return 'Good Afternoon';
      case WakeTheme.evening:
        return 'Good Evening';
      case WakeTheme.night:
        return 'Good Night';
    }
  }

  /// Exposes the time-contextual greeting emoji icon (e.g. "🌅")
  String get greetingIcon {
    switch (_currentTheme) {
      case WakeTheme.morning:
        return '🌅';
      case WakeTheme.afternoon:
        return '☀️';
      case WakeTheme.evening:
        return '🌇';
      case WakeTheme.night:
        return '🌙';
    }
  }

  /// Exposes the primary accent [Color] for the current theme phase
  Color get accentColor {
    switch (_currentTheme) {
      case WakeTheme.morning:
        return const Color(0xFFFF8C42);
      case WakeTheme.afternoon:
        return const Color(0xFFFF6F00);
      case WakeTheme.evening:
        return const Color(0xFFF4511E);
      case WakeTheme.night:
        return const Color(0xFFFBBF24);
    }
  }

  /// Exposes the palette accent colors for the current theme phase
  List<Color> get accentColors {
    switch (_currentTheme) {
      case WakeTheme.morning:
        return const [Color(0xFFF8B133), Color(0xFFFF8C42)];
      case WakeTheme.afternoon:
        return const [Color(0xFFFFA000), Color(0xFFFF6F00)];
      case WakeTheme.evening:
        return const [Color(0xFF8E24AA), Color(0xFFF4511E)];
      case WakeTheme.night:
        return const [Color(0xFF818CF8), Color(0xFFFBBF24)];
    }
  }

  /// Forces an immediate theme evaluation against local device time
  void updateTheme() {
    _evaluateAndSetTheme();
  }

  void _evaluateAndSetTheme() {
    final now = DateTime.now();
    final newTheme = _timeOfDayService.getThemeForTime(now);

    if (_boundaryTimer == null || _currentTheme != newTheme) {
      _currentTheme = newTheme;
      notifyListeners();
    }

    _scheduleNextBoundaryTimer(now);
  }

  void _scheduleNextBoundaryTimer(DateTime now) {
    _boundaryTimer?.cancel();
    final timeUntil = _timeOfDayService.getTimeUntilNextBoundary(now);
    _boundaryTimer = Timer(timeUntil, () {
      _evaluateAndSetTheme();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _evaluateAndSetTheme();
    }
  }

  @override
  void dispose() {
    _boundaryTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
