import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../datasources/alarm_local_datasource.dart';
import '../models/alarm_model.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmLocalDataSource localDataSource;

  AlarmRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Alarm>> getAlarms() async {
    return await localDataSource.getAlarms();
  }

  @override
  Future<void> addAlarm(Alarm alarm) async {
    final model = AlarmModel.fromEntity(alarm);
    await localDataSource.saveAlarm(model);
  }

  @override
  Future<void> updateAlarm(Alarm alarm) async {
    final model = AlarmModel.fromEntity(alarm);
    await localDataSource.saveAlarm(model);
  }

  @override
  Future<void> deleteAlarm(String id) async {
    await localDataSource.deleteAlarm(id);
  }

  @override
  Future<void> toggleAlarm(String id) async {
    await localDataSource.toggleAlarm(id);
  }
}
