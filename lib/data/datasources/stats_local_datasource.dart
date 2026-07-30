import 'package:hive/hive.dart';
import '../models/alarm_history_model.dart';
import '../models/user_stats_model.dart';

abstract class StatsLocalDataSource {
  Future<UserStatsModel> getStats();
  Future<void> saveStats(UserStatsModel stats);
  Future<List<AlarmHistoryModel>> getHistory();
  Future<void> addHistory(AlarmHistoryModel entry);
}

class StatsLocalDataSourceImpl implements StatsLocalDataSource {
  final Box _statsBox;
  final Box _historyBox;

  StatsLocalDataSourceImpl({
    required Box statsBox,
    required Box historyBox,
  })  : _statsBox = statsBox,
        _historyBox = historyBox;

  @override
  Future<UserStatsModel> getStats() async {
    final raw = _statsBox.get('user_stats');
    if (raw != null) {
      final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(raw as Map);
      return UserStatsModel.fromJson(jsonMap);
    }
    return const UserStatsModel();
  }

  @override
  Future<void> saveStats(UserStatsModel stats) async {
    await _statsBox.put('user_stats', stats.toJson());
  }

  @override
  Future<List<AlarmHistoryModel>> getHistory() async {
    final history = <AlarmHistoryModel>[];
    for (var key in _historyBox.keys) {
      final raw = _historyBox.get(key);
      if (raw != null) {
        final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(raw as Map);
        history.add(AlarmHistoryModel.fromJson(jsonMap));
      }
    }
    history.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return history;
  }

  @override
  Future<void> addHistory(AlarmHistoryModel entry) async {
    await _historyBox.put(entry.id, entry.toJson());
  }
}
