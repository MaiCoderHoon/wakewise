import 'package:equatable/equatable.dart';
import 'alarm.dart';

/// Entity recording a completed wake-up session
class AlarmHistory extends Equatable {
  final String id;
  final String alarmId;
  final String alarmLabel;
  final DateTime completedAt;
  final ChallengeType challengeType;
  final int earnedXp;
  final int durationSeconds;

  const AlarmHistory({
    required this.id,
    required this.alarmId,
    required this.alarmLabel,
    required this.completedAt,
    required this.challengeType,
    required this.earnedXp,
    this.durationSeconds = 0,
  });

  @override
  List<Object?> get props => [
        id,
        alarmId,
        alarmLabel,
        completedAt,
        challengeType,
        earnedXp,
        durationSeconds,
      ];
}
