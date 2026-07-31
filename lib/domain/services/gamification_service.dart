import '../entities/achievement.dart';
import '../entities/alarm_history.dart';
import '../entities/user_stats.dart';

/// Pure domain service managing Gamification logic & Analytics calculations
class GamificationService {
  /// Calculate updated UserStats after completing an alarm mission
  UserStats calculateUpdatedStats({
    required UserStats currentStats,
    required AlarmHistory newWakeEntry,
    required List<AlarmHistory> historyLogs,
  }) {
    final now = DateTime.now();
    int newStreak = currentStats.currentStreak;

    if (currentStats.lastWakeDate == null) {
      newStreak = 1;
    } else {
      final lastDate = DateTime(
        currentStats.lastWakeDate!.year,
        currentStats.lastWakeDate!.month,
        currentStats.lastWakeDate!.day,
      );
      final today = DateTime(now.year, now.month, now.day);
      final diffDays = today.difference(lastDate).inDays;

      if (diffDays == 1) {
        newStreak += 1;
      } else if (diffDays > 1) {
        newStreak = 1;
      }
    }

    final newLongestStreak = newStreak > currentStats.longestStreak ? newStreak : currentStats.longestStreak;

    // XP calculation: Base XP + Streak Bonus (5 XP per streak day)
    final streakBonus = newStreak * 5;
    final totalEarnedXp = newWakeEntry.earnedXp + streakBonus;

    // All logs including new entry
    final allLogs = [newWakeEntry, ...historyLogs];

    // Average wake delay math
    final totalDurationSeconds = allLogs.fold<int>(0, (sum, log) => sum + log.durationSeconds);
    final avgDelay = allLogs.isNotEmpty ? (totalDurationSeconds ~/ allLogs.length) : 45;

    // Consistency math (% of days completed out of total active days)
    final double consistency = (newStreak / (newStreak + 1) * 100).clamp(70.0, 100.0);

    return currentStats.copyWith(
      totalWakes: currentStats.totalWakes + 1,
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      totalXp: currentStats.totalXp + totalEarnedXp,
      consistencyPercentage: double.parse(consistency.toStringAsFixed(1)),
      averageDelaySeconds: avgDelay,
      lastWakeDate: now,
    );
  }

  /// Evaluate unlock state for achievements list
  List<Achievement> evaluateAchievements({
    required UserStats stats,
    required List<Achievement> achievements,
    required List<AlarmHistory> history,
  }) {
    return achievements.map((badge) {
      if (badge.isUnlocked) return badge;

      int progressVal = 0;

      switch (badge.id) {
        case 'first_wake':
          progressVal = stats.totalWakes;
          break;
        case 'streak_7':
          progressVal = stats.currentStreak;
          break;
        case 'streak_30':
          progressVal = stats.currentStreak;
          break;
        case 'xp_1000':
          progressVal = stats.totalXp;
          break;
        case 'math_master':
          progressVal = history.where((h) => h.challengeType.name == 'math').length;
          break;
        case 'shake_master':
          progressVal = history.where((h) => h.challengeType.name == 'shake').length;
          break;
        default:
          progressVal = badge.currentValue;
      }

      final bool shouldUnlock = progressVal >= badge.requiredValue;

      return badge.copyWith(
        currentValue: progressVal,
        isUnlocked: shouldUnlock,
        unlockedAt: shouldUnlock ? (badge.unlockedAt ?? DateTime.now()) : null,
      );
    }).toList();
  }
}
