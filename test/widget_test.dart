import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wakewise/core/constants/theme/light_theme.dart';
import 'package:wakewise/data/datasources/alarm_local_datasource.dart';
import 'package:wakewise/data/repositories/alarm_repository_impl.dart';
import 'package:wakewise/main.dart';
import 'package:wakewise/presentation/blocs/alarm/alarm_bloc.dart';
import 'package:wakewise/presentation/blocs/alarm/alarm_event.dart';
import 'package:wakewise/presentation/screens/home_screen.dart';
import 'package:wakewise/presentation/screens/onboarding_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('WakewiseApp initializes and renders successfully', (WidgetTester tester) async {
    Hive.init('./test_hive');
    final box = await Hive.openBox('test_alarms_app');
    final localDataSource = AlarmLocalDataSourceImpl(box);
    final repository = AlarmRepositoryImpl(localDataSource: localDataSource);

    await tester.pumpWidget(WakewiseApp(alarmRepository: repository));
    await tester.pump();

    expect(find.text('WakeWise'), findsOneWidget);
    expect(find.text('Wake Smarter.'), findsOneWidget);

    // Elapse timer so pending microtasks finish cleanly
    await tester.pump(const Duration(seconds: 3));

    await box.close();
  });

  testWidgets('OnboardingScreen renders welcome text and skip button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lightThemeData,
        home: const OnboardingScreen(),
      ),
    );

    await tester.pump();

    expect(find.text('Welcome to WakeWise'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('HomeScreen renders greeting and alarm dashboard', (WidgetTester tester) async {
    Hive.init('./test_hive');
    final box = await Hive.openBox('test_alarms_home');
    final localDataSource = AlarmLocalDataSourceImpl(box);
    final repository = AlarmRepositoryImpl(localDataSource: localDataSource);

    await tester.pumpWidget(
      BlocProvider<AlarmBloc>(
        create: (context) => AlarmBloc(repository: repository)..add(const LoadAlarms()),
        child: MaterialApp(
          theme: lightThemeData,
          home: const HomeScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Good Morning'), findsOneWidget);

    await box.close();
  });
}
