import 'package:equatable/equatable.dart';
import '../../../domain/entities/mission_task.dart';
import '../../../domain/entities/morning_mission.dart';

abstract class MissionState extends Equatable {
  const MissionState();

  @override
  List<Object?> get props => [];
}

class MissionInitial extends MissionState {
  const MissionInitial();
}

/// Mission is active and task is currently in progress
class MissionInProgress extends MissionState {
  final MorningMission mission;
  final String? feedbackMessage;
  final bool isTaskTransitioning;

  const MissionInProgress({
    required this.mission,
    this.feedbackMessage,
    this.isTaskTransitioning = false,
  });

  @override
  List<Object?> get props => [mission, feedbackMessage, isTaskTransitioning];

  MissionInProgress copyWith({
    MorningMission? mission,
    String? feedbackMessage,
    bool? isTaskTransitioning,
  }) {
    return MissionInProgress(
      mission: mission ?? this.mission,
      feedbackMessage: feedbackMessage,
      isTaskTransitioning: isTaskTransitioning ?? this.isTaskTransitioning,
    );
  }
}

/// Single task in mission completed successfully
class MissionTaskSuccess extends MissionState {
  final MorningMission mission;
  final MissionTask completedTask;
  final String message;

  const MissionTaskSuccess({
    required this.mission,
    required this.completedTask,
    required this.message,
  });

  @override
  List<Object?> get props => [mission, completedTask, message];
}

/// All tasks completed! Trigger premium celebration screen
class MissionCelebrationState extends MissionState {
  final MorningMission mission;
  final int totalXpEarned;
  final int newStreak;
  final int newLevel;
  final double levelProgress;

  const MissionCelebrationState({
    required this.mission,
    required this.totalXpEarned,
    required this.newStreak,
    required this.newLevel,
    required this.levelProgress,
  });

  @override
  List<Object?> get props => [
        mission,
        totalXpEarned,
        newStreak,
        newLevel,
        levelProgress,
      ];
}
