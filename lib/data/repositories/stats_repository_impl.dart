import '../../domain/entities/alarm_history.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_local_datasource.dart';
import '../models/alarm_history_model.dart';
import '../models/user_stats_model.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsLocalDataSource localDataSource;

  StatsRepositoryImpl({required this.localDataSource});

  @override
  Future<UserStats> getStats() async {
    return await localDataSource.getStats();
  }

  @override
  Future<void> updateStats(UserStats stats) async {
    final model = UserStatsModel.fromEntity(stats);
    await localDataSource.saveStats(model);
  }

  @override
  Future<List<AlarmHistory>> getHistory() async {
    return await localDataSource.getHistory();
  }

  @override
  Future<void> addHistory(AlarmHistory entry) async {
    final model = AlarmHistoryModel.fromEntity(entry);
    await localDataSource.addHistory(model);
  }
}
