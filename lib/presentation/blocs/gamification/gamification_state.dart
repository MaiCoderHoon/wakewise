import 'package:equatable/equatable.dart';
import '../../../domain/entities/achievement.dart';
import '../../../domain/entities/alarm_history.dart';
import '../../../domain/entities/user_stats.dart';

abstract class GamificationState extends Equatable {
  const GamificationState();

  @override
  List<Object?> get props => [];
}

class GamificationInitial extends GamificationState {
  const GamificationInitial();
}

class GamificationLoading extends GamificationState {
  const GamificationLoading();
}

class GamificationLoaded extends GamificationState {
  final UserStats stats;
  final List<Achievement> achievements;
  final List<AlarmHistory> history;
  final List<Achievement> newlyUnlocked;

  const GamificationLoaded({
    required this.stats,
    required this.achievements,
    required this.history,
    this.newlyUnlocked = const [],
  });

  @override
  List<Object?> get props => [stats, achievements, history, newlyUnlocked];
}
