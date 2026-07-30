import 'package:equatable/equatable.dart';
import '../../../domain/challenges/entities/challenge_difficulty.dart';

abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize challenge session
class StartChallenge extends ChallengeEvent {
  final String challengeKey; // 'math', 'memory', 'shake', 'random'
  final ChallengeDifficulty difficulty;

  const StartChallenge({
    required this.challengeKey,
    this.difficulty = ChallengeDifficulty.medium,
  });

  @override
  List<Object?> get props => [challengeKey, difficulty];
}

/// Submit user attempt / step input
class SubmitAnswer extends ChallengeEvent {
  final dynamic payload;

  const SubmitAnswer(this.payload);

  @override
  List<Object?> get props => [payload];
}

/// Retry current challenge
class RetryChallenge extends ChallengeEvent {
  const RetryChallenge();
}

/// Complete challenge session and return result
class CompleteChallenge extends ChallengeEvent {
  const CompleteChallenge();
}
