import '../../domain/entities/alarm.dart';

/// Alarm Model for Serialization
class AlarmModel extends Alarm {
  const AlarmModel({
    required super.id,
    required super.hour,
    required super.minute,
    required super.label,
    required super.repeatDays,
    required super.challengeType,
    required super.enabled,
    required super.createdAt,
  });

  /// Factory from Alarm Entity
  factory AlarmModel.fromEntity(Alarm alarm) {
    return AlarmModel(
      id: alarm.id,
      hour: alarm.hour,
      minute: alarm.minute,
      label: alarm.label,
      repeatDays: alarm.repeatDays,
      challengeType: alarm.challengeType,
      enabled: alarm.enabled,
      createdAt: alarm.createdAt,
    );
  }

  /// Serialize to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'label': label,
      'repeatDays': repeatDays,
      'challengeType': challengeType.name,
      'enabled': enabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Deserialize from JSON Map
  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      label: json['label'] as String? ?? 'Alarm',
      repeatDays: (json['repeatDays'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      challengeType: ChallengeType.values.firstWhere(
        (c) => c.name == (json['challengeType'] as String?),
        orElse: () => ChallengeType.none,
      ),
      enabled: json['enabled'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
