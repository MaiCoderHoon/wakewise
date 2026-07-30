import '../entities/alarm.dart';

/// Abstract Alarm Repository contract
abstract class AlarmRepository {
  Future<List<Alarm>> getAlarms();
  Future<void> addAlarm(Alarm alarm);
  Future<void> updateAlarm(Alarm alarm);
  Future<void> deleteAlarm(String id);
  Future<void> toggleAlarm(String id);
}
