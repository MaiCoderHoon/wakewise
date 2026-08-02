import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wakewise/core/services/time_of_day_service.dart';
import 'package:wakewise/core/theme/dynamic_theme_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimeOfDayService Tests', () {
    const service = TimeOfDayService();

    test('Determines correct WakeTheme for time of day boundaries', () {
      // 🌅 Morning: 5:00 AM – 11:00 AM
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 5, 0)), WakeTheme.morning);
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 10, 59)), WakeTheme.morning);

      // ☀️ Afternoon: 11:00 AM – 5:00 PM
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 11, 0)), WakeTheme.afternoon);
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 16, 59)), WakeTheme.afternoon);

      // 🌇 Evening: 5:00 PM – 8:00 PM
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 17, 0)), WakeTheme.evening);
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 19, 59)), WakeTheme.evening);

      // 🌙 Night: 8:00 PM – 5:00 AM
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 20, 0)), WakeTheme.night);
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 23, 59)), WakeTheme.night);
      expect(service.getThemeForTime(DateTime(2026, 1, 1, 2, 0)), WakeTheme.night);
    });

    test('Calculates correct next theme boundary', () {
      // At 7:00 AM, next boundary is 11:00 AM
      final nextFromMorning = service.getNextBoundary(DateTime(2026, 1, 1, 7, 0));
      expect(nextFromMorning.hour, 11);

      // At 1:00 PM, next boundary is 5:00 PM (17:00)
      final nextFromAfternoon = service.getNextBoundary(DateTime(2026, 1, 1, 13, 0));
      expect(nextFromAfternoon.hour, 17);

      // At 6:00 PM, next boundary is 8:00 PM (20:00)
      final nextFromEvening = service.getNextBoundary(DateTime(2026, 1, 1, 18, 0));
      expect(nextFromEvening.hour, 20);

      // At 9:00 PM, next boundary is 5:00 AM tomorrow
      final nextFromNight = service.getNextBoundary(DateTime(2026, 1, 1, 21, 0));
      expect(nextFromNight.hour, 5);
      expect(nextFromNight.day, 2);
    });
  });

  group('DynamicThemeManager Tests', () {
    test('Exposes valid theme data, gradient, greeting, and icons for each phase', () {
      final manager = DynamicThemeManager();

      expect(manager.currentThemeData, isA<ThemeData>());
      expect(manager.currentGradient, isA<LinearGradient>());
      expect(manager.greeting, isNotEmpty);
      expect(manager.greetingIcon, isNotEmpty);
      expect(manager.accentColor, isA<Color>());
      expect(manager.accentColors, isNotEmpty);

      manager.dispose();
    });
  });
}
