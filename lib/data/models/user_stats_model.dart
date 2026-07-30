import '../../domain/entities/user_stats.dart';

class UserStatsModel extends UserStats {
  const UserStatsModel({
    super.totalWakes,
    super.currentStreak,
    super.totalXp,
    super.lastWakeDate,
  });

  factory UserStatsModel.fromEntity(UserStats entity) {
    return UserStatsModel(
      totalWakes: entity.totalWakes,
      currentStreak: entity.currentStreak,
      totalXp: entity.totalXp,
      lastWakeDate: entity.lastWakeDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWakes': totalWakes,
      'currentStreak': currentStreak,
      'totalXp': totalXp,
      'lastWakeDate': lastWakeDate?.toIso8601String(),
    };
  }

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalWakes: json['totalWakes'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      totalXp: json['totalXp'] as int? ?? 0,
      lastWakeDate: json['lastWakeDate'] != null
          ? DateTime.parse(json['lastWakeDate'] as String)
          : null,
    );
  }
}
