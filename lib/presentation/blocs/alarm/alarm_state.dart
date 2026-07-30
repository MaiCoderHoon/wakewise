import 'package:equatable/equatable.dart';
import '../../../domain/entities/alarm.dart';

abstract class AlarmState extends Equatable {
  const AlarmState();

  @override
  List<Object?> get props => [];
}

class AlarmInitial extends AlarmState {
  const AlarmInitial();
}

class AlarmLoading extends AlarmState {
  const AlarmLoading();
}

class AlarmLoaded extends AlarmState {
  final List<Alarm> alarms;

  const AlarmLoaded({required this.alarms});

  /// Convenience getter for enabled upcoming alarm
  Alarm? get upcomingAlarm {
    final enabledAlarms = alarms.where((a) => a.enabled).toList();
    if (enabledAlarms.isEmpty) return null;

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    // Find first enabled alarm later today, or fallback to earliest alarm tomorrow
    enabledAlarms.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));

    for (var alarm in enabledAlarms) {
      if ((alarm.hour * 60 + alarm.minute) > currentMinutes) {
        return alarm;
      }
    }
    return enabledAlarms.first;
  }

  @override
  List<Object?> get props => [alarms];
}

class AlarmError extends AlarmState {
  final String message;

  const AlarmError(this.message);

  @override
  List<Object?> get props => [message];
}
