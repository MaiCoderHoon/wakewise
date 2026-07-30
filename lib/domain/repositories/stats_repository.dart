import '../entities/alarm_history.dart';
import '../entities/user_stats.dart';

abstract class StatsRepository {
  Future<UserStats> getStats();
  Future<void> updateStats(UserStats stats);
  Future<List<AlarmHistory>> getHistory();
  Future<void> addHistory(AlarmHistory entry);
}
