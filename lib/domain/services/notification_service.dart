import '../entities/alarm.dart';

/// Abstract Notification Service contract isolating platform local notifications from UI & BLoC
abstract class NotificationService {
  Future<void> initialize();
  Future<void> scheduleAlarm(Alarm alarm);
  Future<void> cancelAlarm(String alarmId);
  Future<void> cancelAllAlarms();
  Future<void> syncAlarms(List<Alarm> alarms);
}
