import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/theme/light_theme.dart';
import 'data/datasources/alarm_local_datasource.dart';
import 'data/repositories/alarm_repository_impl.dart';
import 'domain/repositories/alarm_repository.dart';
import 'presentation/blocs/alarm/alarm_bloc.dart';
import 'presentation/blocs/alarm/alarm_event.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local storage
  await Hive.initFlutter();
  final alarmBox = await Hive.openBox('alarms');

  // Dependency Injection
  final AlarmLocalDataSource localDataSource = AlarmLocalDataSourceImpl(alarmBox);
  final AlarmRepository repository = AlarmRepositoryImpl(localDataSource: localDataSource);

  runApp(WakewiseApp(alarmRepository: repository));
}

class WakewiseApp extends StatelessWidget {
  final AlarmRepository alarmRepository;

  const WakewiseApp({
    super.key,
    required this.alarmRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AlarmBloc>(
      create: (context) => AlarmBloc(repository: alarmRepository)..add(const LoadAlarms()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'WakeWise',
        theme: lightThemeData,
        routerConfig: appRouter,
      ),
    );
  }
}