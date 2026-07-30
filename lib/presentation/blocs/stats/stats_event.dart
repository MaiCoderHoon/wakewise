import 'package:equatable/equatable.dart';
import '../../../domain/entities/alarm_history.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadStats extends StatsEvent {
  const LoadStats();
}

class RecordWakeUp extends StatsEvent {
  final AlarmHistory historyEntry;

  const RecordWakeUp(this.historyEntry);

  @override
  List<Object?> get props => [historyEntry];
}
