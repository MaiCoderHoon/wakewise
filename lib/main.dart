import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'core/services/time_of_day_service.dart';
import 'core/theme/dynamic_theme_manager.dart';
import 'data/datasources/achievement_local_datasource.dart';
import 'data/datasources/alarm_local_datasource.dart';
import 'data/datasources/stats_local_datasource.dart';
import 'data/repositories/achievement_repository_impl.dart';
import 'data/repositories/alarm_repository_impl.dart';
import 'data/repositories/stats_repository_impl.dart';
import 'data/services/notification_service_impl.dart';
import 'domain/repositories/achievement_repository.dart';
import 'domain/repositories/alarm_repository.dart';
import 'domain/repositories/stats_repository.dart';
import 'domain/services/notification_service.dart';
import 'presentation/blocs/alarm/alarm_bloc.dart';
import 'presentation/blocs/alarm/alarm_event.dart';
import 'presentation/blocs/gamification/gamification_bloc.dart';
import 'presentation/blocs/gamification/gamification_event.dart';
import 'presentation/blocs/stats/stats_bloc.dart';
import 'presentation/blocs/stats/stats_event.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-warm liquid glass shaders (prevents white flash on first render)
  await LiquidGlassWidgets.initialize();

  // Initialize Hive local storage
  await Hive.initFlutter();
  final alarmBox = await Hive.openBox('alarms');
  final statsBox = await Hive.openBox('stats');
  final historyBox = await Hive.openBox('history');
  final achievementBox = await Hive.openBox('achievements');

  // Initialize Notification Service
  final NotificationService notificationService = NotificationServiceImpl();
  await notificationService.initialize();

  // Dependency Injection
  final AlarmLocalDataSource alarmDataSource = AlarmLocalDataSourceImpl(alarmBox);
  final AlarmRepository alarmRepository = AlarmRepositoryImpl(localDataSource: alarmDataSource);

  final StatsLocalDataSource statsDataSource = StatsLocalDataSourceImpl(
    statsBox: statsBox,
    historyBox: historyBox,
  );
  final StatsRepository statsRepository = StatsRepositoryImpl(localDataSource: statsDataSource);

  final AchievementLocalDataSource achievementDataSource = AchievementLocalDataSourceImpl(achievementBox);
  final AchievementRepository achievementRepository = AchievementRepositoryImpl(localDataSource: achievementDataSource);

  // Initialize Circadian Dynamic Theme Architecture
  const timeOfDayService = TimeOfDayService();
  final dynamicThemeManager = DynamicThemeManager(timeOfDayService: timeOfDayService);

  runApp(
    LiquidGlassWidgets.wrap(
      adaptiveQuality: true,
      child: WakewiseApp(
        alarmRepository: alarmRepository,
        statsRepository: statsRepository,
        achievementRepository: achievementRepository,
        notificationService: notificationService,
        dynamicThemeManager: dynamicThemeManager,
      ),
    ),
  );
}

class WakewiseApp extends StatelessWidget {
  final AlarmRepository alarmRepository;
  final StatsRepository statsRepository;
  final AchievementRepository achievementRepository;
  final NotificationService notificationService;
  final DynamicThemeManager? dynamicThemeManager;

  const WakewiseApp({
    super.key,
    required this.alarmRepository,
    required this.statsRepository,
    required this.achievementRepository,
    required this.notificationService,
    this.dynamicThemeManager,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = dynamicThemeManager ?? DynamicThemeManager();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AlarmBloc>(
          create: (context) => AlarmBloc(
            repository: alarmRepository,
            notificationService: notificationService,
          )..add(const LoadAlarms()),
        ),
        BlocProvider<StatsBloc>(
          create: (context) => StatsBloc(
            repository: statsRepository,
          )..add(const LoadStats()),
        ),
        BlocProvider<GamificationBloc>(
          create: (context) => GamificationBloc(
            statsRepository: statsRepository,
            achievementRepository: achievementRepository,
          )..add(const LoadGamificationData()),
        ),
      ],
      child: ListenableBuilder(
        listenable: themeManager,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'WakeWise',
            theme: themeManager.currentThemeData,
            routerConfig: appRouter,
            builder: (context, child) {
              return AnimatedTheme(
                data: themeManager.currentThemeData,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}