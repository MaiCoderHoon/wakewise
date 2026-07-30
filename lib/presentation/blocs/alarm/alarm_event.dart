import 'package:equatable/equatable.dart';
import '../../../domain/entities/alarm.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object?> get props => [];
}

/// Load all alarms from local persistence
class LoadAlarms extends AlarmEvent {
  const LoadAlarms();
}

/// Add a new alarm
class AddAlarm extends AlarmEvent {
  final Alarm alarm;

  const AddAlarm(this.alarm);

  @override
  List<Object?> get props => [alarm];
}

/// Update an existing alarm
class UpdateAlarm extends AlarmEvent {
  final Alarm alarm;

  const UpdateAlarm(this.alarm);

  @override
  List<Object?> get props => [alarm];
}

/// Delete an alarm by ID
class DeleteAlarm extends AlarmEvent {
  final String id;

  const DeleteAlarm(this.id);

  @override
  List<Object?> get props => [id];
}

/// Toggle enabled status for an alarm
class ToggleAlarm extends AlarmEvent {
  final String id;

  const ToggleAlarm(this.id);

  @override
  List<Object?> get props => [id];
}
