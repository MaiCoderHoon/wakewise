import 'package:equatable/equatable.dart';
import '../../../domain/challenges/entities/base_challenge.dart';
import '../../../domain/challenges/entities/challenge_result.dart';

abstract class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object?> get props => [];
}

class ChallengeInitial extends ChallengeState {
  const ChallengeInitial();
}

class ChallengeInProgress extends ChallengeState {
  final BaseChallenge challenge;
  final String? feedbackMessage;
  final int attemptCount;

  const ChallengeInProgress({
    required this.challenge,
    this.feedbackMessage,
    this.attemptCount = 0,
  });

  @override
  List<Object?> get props => [challenge, feedbackMessage, attemptCount];
}

class ChallengeSuccess extends ChallengeState {
  final BaseChallenge challenge;
  final ChallengeResult result;

  const ChallengeSuccess({
    required this.challenge,
    required this.result,
  });

  @override
  List<Object?> get props => [challenge, result];
}

class ChallengeFailed extends ChallengeState {
  final BaseChallenge challenge;
  final String message;

  const ChallengeFailed({
    required this.challenge,
    required this.message,
  });

  @override
  List<Object?> get props => [challenge, message];
}
