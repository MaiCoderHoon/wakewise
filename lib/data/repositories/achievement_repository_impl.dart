import '../../domain/entities/achievement.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../datasources/achievement_local_datasource.dart';
import '../models/achievement_model.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementLocalDataSource localDataSource;

  AchievementRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Achievement>> getAchievements() async {
    return await localDataSource.getAchievements();
  }

  @override
  Future<void> saveAchievements(List<Achievement> achievements) async {
    final models = achievements.map((e) => AchievementModel.fromEntity(e)).toList();
    await localDataSource.saveAchievements(models);
  }
}
