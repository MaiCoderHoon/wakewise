import 'package:equatable/equatable.dart';
import '../../../domain/challenges/entities/base_challenge.dart';
import '../../../domain/challenges/entities/challenge_difficulty.dart';

abstract class MissionEvent extends Equatable {
  const MissionEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize and launch a new Morning Quest mission
class StartMorningMission extends MissionEvent {
  final List<BaseChallenge>? customChallenges;
  final ChallengeDifficulty difficulty;

  const StartMorningMission({
    this.customChallenges,
    this.difficulty = ChallengeDifficulty.medium,
  });

  @override
  List<Object?> get props => [customChallenges, difficulty];
}

/// Submit user response for the active mission task
class SubmitTaskAnswer extends MissionEvent {
  final dynamic payload;

  const SubmitTaskAnswer(this.payload);

  @override
  List<Object?> get props => [payload];
}

/// Manually request advancing to the next task in queue
class AdvanceToNextTask extends MissionEvent {
  const AdvanceToNextTask();
}

/// Finalize mission, calculate streak, award XP and trigger celebration
class CompleteMissionEvent extends MissionEvent {
  const CompleteMissionEvent();
}
