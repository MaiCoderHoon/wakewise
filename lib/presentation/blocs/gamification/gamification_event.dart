import 'package:equatable/equatable.dart';
import '../../../domain/entities/alarm_history.dart';

abstract class GamificationEvent extends Equatable {
  const GamificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadGamificationData extends GamificationEvent {
  const LoadGamificationData();
}

class EvaluateGamificationOnWake extends GamificationEvent {
  final AlarmHistory wakeEntry;

  const EvaluateGamificationOnWake(this.wakeEntry);

  @override
  List<Object?> get props => [wakeEntry];
}
