import 'package:equatable/equatable.dart';

enum ChallengeResultStatus {
  inProgress,
  success,
  failure,
}

/// Evaluation result returned by challenge execution
class ChallengeResult extends Equatable {
  final ChallengeResultStatus status;
  final String message;
  final int earnedXp;
  final int attempts;

  const ChallengeResult({
    required this.status,
    this.message = '',
    this.earnedXp = 0,
    this.attempts = 1,
  });

  bool get isSuccess => status == ChallengeResultStatus.success;
  bool get isFailure => status == ChallengeResultStatus.failure;
  bool get isInProgress => status == ChallengeResultStatus.inProgress;

  @override
  List<Object?> get props => [status, message, earnedXp, attempts];
}
