import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wakewise/core/constants/theme/light_theme.dart';
import 'package:wakewise/domain/entities/alarm.dart';
import 'package:wakewise/presentation/screens/onboarding_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Alarm Entity Unit Tests', () {
    test('Alarm entity formats 12-hour time and period correctly', () {
      final alarm = Alarm(
        id: '1',
        hour: 7,
        minute: 30,
        label: 'Morning Alarm',
        repeatDays: const [1, 2, 3, 4, 5],
        challengeType: ChallengeType.math,
        enabled: true,
        createdAt: DateTime(2026, 1, 1),
      );

      expect(alarm.formattedTime, '07:30');
      expect(alarm.formattedPeriod, 'AM');
      expect(alarm.formattedRepeatDays, 'Weekdays');
      expect(alarm.challengeType.displayName, 'Math Challenge');
    });

    test('Alarm entity formats PM time and weekend repeat days correctly', () {
      final alarm = Alarm(
        id: '2',
        hour: 20,
        minute: 5,
        label: 'Evening Wind Down',
        repeatDays: const [6, 7],
        challengeType: ChallengeType.qr,
        enabled: false,
        createdAt: DateTime(2026, 1, 1),
      );

      expect(alarm.formattedTime, '08:05');
      expect(alarm.formattedPeriod, 'PM');
      expect(alarm.formattedRepeatDays, 'Weekends');
    });
  });

  group('UI Widget Tests', () {
    testWidgets('OnboardingScreen renders title and skip button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lightThemeData,
          home: const OnboardingScreen(),
        ),
      );

      expect(find.text('Welcome to WakeWise'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });
  });
}
