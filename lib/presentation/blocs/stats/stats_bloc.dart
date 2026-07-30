import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_stats.dart';
import '../../../domain/repositories/stats_repository.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final StatsRepository repository;

  StatsBloc({required this.repository}) : super(const StatsInitial()) {
    on<LoadStats>(_onLoadStats);
    on<RecordWakeUp>(_onRecordWakeUp);
  }

  Future<void> _onLoadStats(LoadStats event, Emitter<StatsState> emit) async {
    emit(const StatsLoading());
    try {
      final stats = await repository.getStats();
      final history = await repository.getHistory();
      emit(StatsLoaded(stats: stats, history: history));
    } catch (_) {
      emit(const StatsLoaded(stats: UserStats(), history: []));
    }
  }

  Future<void> _onRecordWakeUp(RecordWakeUp event, Emitter<StatsState> emit) async {
    try {
      final currentStats = await repository.getStats();
      final now = DateTime.now();

      // Calculate streak logic
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

      final updatedStats = currentStats.copyWith(
        totalWakes: currentStats.totalWakes + 1,
        currentStreak: newStreak,
        totalXp: currentStats.totalXp + event.historyEntry.earnedXp,
        lastWakeDate: now,
      );

      await repository.addHistory(event.historyEntry);
      await repository.updateStats(updatedStats);

      final history = await repository.getHistory();
      emit(StatsLoaded(stats: updatedStats, history: history));
    } catch (_) {
      // Retain current loaded state if available
    }
  }
}
