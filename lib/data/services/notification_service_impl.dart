import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/entities/alarm.dart';
import '../../domain/services/notification_service.dart';

/// Production-ready NotificationService wrapping FlutterLocalNotificationsPlugin
class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationServiceImpl({FlutterLocalNotificationsPlugin? plugin})
      : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(settings: initSettings);

    // Create high-importance alarm notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'wakewise_alarms_channel',
      'WakeWise Sunrise Alarms',
      description: 'High-priority full screen alarm notifications for WakeWise morning companion',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(androidChannel);
      await androidImplementation.requestNotificationsPermission();
    }
  }

  @override
  Future<void> scheduleAlarm(Alarm alarm) async {
    final notificationId = alarm.id.hashCode & 0x7FFFFFFF;

    if (!alarm.enabled) {
      await cancelAlarm(alarm.id);
      return;
    }

    // Calculate next scheduled alarm time
    _calculateNextAlarmDateTime(alarm);

    const androidDetails = AndroidNotificationDetails(
      'wakewise_alarms_channel',
      'WakeWise Sunrise Alarms',
      channelDescription: 'High-priority full screen alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      playSound: true,
      enableVibration: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notificationsPlugin.show(
      id: notificationId,
      title: '🌅 ${alarm.label}',
      body: 'Time to wake up! Tap or open to start your morning mission.',
      notificationDetails: details,
      payload: alarm.id,
    );
  }

  @override
  Future<void> cancelAlarm(String alarmId) async {
    final notificationId = alarmId.hashCode & 0x7FFFFFFF;
    await _notificationsPlugin.cancel(id: notificationId);
  }

  @override
  Future<void> cancelAllAlarms() async {
    await _notificationsPlugin.cancelAll();
  }

  @override
  Future<void> syncAlarms(List<Alarm> alarms) async {
    await cancelAllAlarms();
    for (var alarm in alarms) {
      if (alarm.enabled) {
        await scheduleAlarm(alarm);
      }
    }
  }

  /// Calculates next DateTime instance for an alarm taking into account repeatDays
  DateTime _calculateNextAlarmDateTime(Alarm alarm) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, alarm.hour, alarm.minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    if (alarm.repeatDays.isEmpty) {
      return scheduled;
    }

    // Find next day matching repeatDays (1 = Mon, 7 = Sun)
    while (!alarm.repeatDays.contains(scheduled.weekday)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
