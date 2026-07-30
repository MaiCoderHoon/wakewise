import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/alarm_repository.dart';
import '../../../domain/services/notification_service.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository repository;
  final NotificationService? notificationService;

  AlarmBloc({
    required this.repository,
    this.notificationService,
  }) : super(const AlarmInitial()) {
    on<LoadAlarms>(_onLoadAlarms);
    on<AddAlarm>(_onAddAlarm);
    on<UpdateAlarm>(_onUpdateAlarm);
    on<DeleteAlarm>(_onDeleteAlarm);
    on<ToggleAlarm>(_onToggleAlarm);
  }

  Future<void> _onLoadAlarms(LoadAlarms event, Emitter<AlarmState> emit) async {
    emit(const AlarmLoading());
    try {
      final alarms = await repository.getAlarms();
      await notificationService?.syncAlarms(alarms);
      emit(AlarmLoaded(alarms: alarms));
    } catch (e) {
      emit(AlarmError('Failed to load alarms: ${e.toString()}'));
    }
  }

  Future<void> _onAddAlarm(AddAlarm event, Emitter<AlarmState> emit) async {
    try {
      await repository.addAlarm(event.alarm);
      await notificationService?.scheduleAlarm(event.alarm);
      final alarms = await repository.getAlarms();
      emit(AlarmLoaded(alarms: alarms));
    } catch (e) {
      emit(AlarmError('Failed to add alarm: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateAlarm(UpdateAlarm event, Emitter<AlarmState> emit) async {
    try {
      await repository.updateAlarm(event.alarm);
      await notificationService?.scheduleAlarm(event.alarm);
      final alarms = await repository.getAlarms();
      emit(AlarmLoaded(alarms: alarms));
    } catch (e) {
      emit(AlarmError('Failed to update alarm: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAlarm(DeleteAlarm event, Emitter<AlarmState> emit) async {
    try {
      await repository.deleteAlarm(event.id);
      await notificationService?.cancelAlarm(event.id);
      final alarms = await repository.getAlarms();
      emit(AlarmLoaded(alarms: alarms));
    } catch (e) {
      emit(AlarmError('Failed to delete alarm: ${e.toString()}'));
    }
  }

  Future<void> _onToggleAlarm(ToggleAlarm event, Emitter<AlarmState> emit) async {
    try {
      await repository.toggleAlarm(event.id);
      final alarms = await repository.getAlarms();
      final updatedAlarm = alarms.firstWhere((a) => a.id == event.id);
      if (updatedAlarm.enabled) {
        await notificationService?.scheduleAlarm(updatedAlarm);
      } else {
        await notificationService?.cancelAlarm(event.id);
      }
      emit(AlarmLoaded(alarms: alarms));
    } catch (e) {
      emit(AlarmError('Failed to toggle alarm: ${e.toString()}'));
    }
  }
}
