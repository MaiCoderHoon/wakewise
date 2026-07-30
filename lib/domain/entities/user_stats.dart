import 'package:equatable/equatable.dart';

/// User Stats Entity for tracking morning streak, XP, and level
class UserStats extends Equatable {
  final int totalWakes;
  final int currentStreak;
  final int totalXp;
  final DateTime? lastWakeDate;

  const UserStats({
    this.totalWakes = 0,
    this.currentStreak = 0,
    this.totalXp = 0,
    this.lastWakeDate,
  });

  /// Computed user level (100 XP per level)
  int get level => (totalXp ~/ 100) + 1;

  /// Progress towards next level (0.0 to 1.0)
  double get levelProgress => (totalXp % 100) / 100.0;

  UserStats copyWith({
    int? totalWakes,
    int? currentStreak,
    int? totalXp,
    DateTime? lastWakeDate,
  }) {
    return UserStats(
      totalWakes: totalWakes ?? this.totalWakes,
      currentStreak: currentStreak ?? this.currentStreak,
      totalXp: totalXp ?? this.totalXp,
      lastWakeDate: lastWakeDate ?? this.lastWakeDate,
    );
  }

  @override
  List<Object?> get props => [totalWakes, currentStreak, totalXp, lastWakeDate];
}
