import 'package:equatable/equatable.dart';
import '../../../domain/entities/alarm_history.dart';
import '../../../domain/entities/user_stats.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {
  const StatsInitial();
}

class StatsLoading extends StatsState {
  const StatsLoading();
}

class StatsLoaded extends StatsState {
  final UserStats stats;
  final List<AlarmHistory> history;

  const StatsLoaded({
    required this.stats,
    required this.history,
  });

  @override
  List<Object?> get props => [stats, history];
}
