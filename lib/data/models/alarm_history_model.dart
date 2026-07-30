import '../../domain/entities/alarm.dart';
import '../../domain/entities/alarm_history.dart';

class AlarmHistoryModel extends AlarmHistory {
  const AlarmHistoryModel({
    required super.id,
    required super.alarmId,
    required super.alarmLabel,
    required super.completedAt,
    required super.challengeType,
    required super.earnedXp,
    super.durationSeconds,
  });

  factory AlarmHistoryModel.fromEntity(AlarmHistory entity) {
    return AlarmHistoryModel(
      id: entity.id,
      alarmId: entity.alarmId,
      alarmLabel: entity.alarmLabel,
      completedAt: entity.completedAt,
      challengeType: entity.challengeType,
      earnedXp: entity.earnedXp,
      durationSeconds: entity.durationSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alarmId': alarmId,
      'alarmLabel': alarmLabel,
      'completedAt': completedAt.toIso8601String(),
      'challengeType': challengeType.name,
      'earnedXp': earnedXp,
      'durationSeconds': durationSeconds,
    };
  }

  factory AlarmHistoryModel.fromJson(Map<String, dynamic> json) {
    return AlarmHistoryModel(
      id: json['id'] as String,
      alarmId: json['alarmId'] as String? ?? '',
      alarmLabel: json['alarmLabel'] as String? ?? 'Alarm',
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : DateTime.now(),
      challengeType: ChallengeType.values.firstWhere(
        (c) => c.name == (json['challengeType'] as String?),
        orElse: () => ChallengeType.none,
      ),
      earnedXp: json['earnedXp'] as int? ?? 10,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
    );
  }
}
