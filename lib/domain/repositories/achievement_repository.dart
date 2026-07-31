import '../entities/achievement.dart';

abstract class AchievementRepository {
  Future<List<Achievement>> getAchievements();
  Future<void> saveAchievements(List<Achievement> achievements);
}
