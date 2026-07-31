import 'package:hive/hive.dart';
import '../models/achievement_model.dart';

abstract class AchievementLocalDataSource {
  Future<List<AchievementModel>> getAchievements();
  Future<void> saveAchievements(List<AchievementModel> achievements);
}

class AchievementLocalDataSourceImpl implements AchievementLocalDataSource {
  final Box _box;

  AchievementLocalDataSourceImpl(this._box);

  static final List<AchievementModel> defaultAchievements = [
    const AchievementModel(
      id: 'first_wake',
      title: 'First Sunrise',
      description: 'Complete your very first wake-up mission.',
      iconName: 'wb_sunny_rounded',
      requiredValue: 1,
    ),
    const AchievementModel(
      id: 'streak_7',
      title: 'Week Warrior',
      description: 'Maintain a 7-day wake-up streak without missing a day.',
      iconName: 'local_fire_department_rounded',
      requiredValue: 7,
    ),
    const AchievementModel(
      id: 'streak_30',
      title: 'Early Bird Titan',
      description: 'Conquer early mornings for 30 consecutive days.',
      iconName: 'workspace_premium_rounded',
      requiredValue: 30,
    ),
    const AchievementModel(
      id: 'xp_1000',
      title: 'XP Overachiever',
      description: 'Earn 1,000 total XP from wake-up missions.',
      iconName: 'bolt_rounded',
      requiredValue: 1000,
    ),
    const AchievementModel(
      id: 'math_master',
      title: 'Math Genius',
      description: 'Solve 5 morning arithmetic equation missions.',
      iconName: 'calculate_rounded',
      requiredValue: 5,
    ),
    const AchievementModel(
      id: 'shake_master',
      title: 'Shake Dynamo',
      description: 'Complete 5 physical shake motion challenges.',
      iconName: 'vibration_rounded',
      requiredValue: 5,
    ),
  ];

  @override
  Future<List<AchievementModel>> getAchievements() async {
    if (_box.isEmpty) {
      for (var model in defaultAchievements) {
        await _box.put(model.id, model.toJson());
      }
      return defaultAchievements;
    }

    final list = <AchievementModel>[];
    for (var key in _box.keys) {
      final raw = _box.get(key);
      if (raw != null) {
        final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(raw as Map);
        list.add(AchievementModel.fromJson(jsonMap));
      }
    }
    return list;
  }

  @override
  Future<void> saveAchievements(List<AchievementModel> achievements) async {
    for (var item in achievements) {
      await _box.put(item.id, item.toJson());
    }
  }
}
