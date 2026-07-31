import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/achievement.dart';
import '../../../domain/entities/user_stats.dart';
import '../../../domain/repositories/achievement_repository.dart';
import '../../../domain/repositories/stats_repository.dart';
import '../../../domain/services/gamification_service.dart';
import 'gamification_event.dart';
import 'gamification_state.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  final StatsRepository statsRepository;
  final AchievementRepository achievementRepository;
  final GamificationService gamificationService;

  GamificationBloc({
    required this.statsRepository,
    required this.achievementRepository,
    GamificationService? gamificationService,
  })  : gamificationService = gamificationService ?? GamificationService(),
        super(const GamificationInitial()) {
    on<LoadGamificationData>(_onLoadGamificationData);
    on<EvaluateGamificationOnWake>(_onEvaluateGamificationOnWake);
  }

  Future<void> _onLoadGamificationData(
    LoadGamificationData event,
    Emitter<GamificationState> emit,
  ) async {
    emit(const GamificationLoading());
    try {
      final stats = await statsRepository.getStats();
      final history = await statsRepository.getHistory();
      final achievements = await achievementRepository.getAchievements();

      final updatedBadges = gamificationService.evaluateAchievements(
        stats: stats,
        achievements: achievements,
        history: history,
      );

      await achievementRepository.saveAchievements(updatedBadges);

      emit(GamificationLoaded(
        stats: stats,
        achievements: updatedBadges,
        history: history,
      ));
    } catch (_) {
      emit(const GamificationLoaded(
        stats: UserStats(),
        achievements: [],
        history: [],
      ));
    }
  }

  Future<void> _onEvaluateGamificationOnWake(
    EvaluateGamificationOnWake event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      final currentStats = await statsRepository.getStats();
      final historyLogs = await statsRepository.getHistory();
      final currentBadges = await achievementRepository.getAchievements();

      // 1. Calculate updated stats via GamificationService
      final updatedStats = gamificationService.calculateUpdatedStats(
        currentStats: currentStats,
        newWakeEntry: event.wakeEntry,
        historyLogs: historyLogs,
      );

      // Save wake entry & updated stats
      await statsRepository.addHistory(event.wakeEntry);
      await statsRepository.updateStats(updatedStats);

      final updatedHistory = await statsRepository.getHistory();

      // 2. Evaluate achievement unlocks
      final evaluatedBadges = gamificationService.evaluateAchievements(
        stats: updatedStats,
        achievements: currentBadges,
        history: updatedHistory,
      );

      // Identify newly unlocked badges
      final newlyUnlocked = <Achievement>[];
      for (var evaluated in evaluatedBadges) {
        final previous = currentBadges.firstWhere(
          (b) => b.id == evaluated.id,
          orElse: () => evaluated,
        );
        if (!previous.isUnlocked && evaluated.isUnlocked) {
          newlyUnlocked.add(evaluated);
        }
      }

      await achievementRepository.saveAchievements(evaluatedBadges);

      emit(GamificationLoaded(
        stats: updatedStats,
        achievements: evaluatedBadges,
        history: updatedHistory,
        newlyUnlocked: newlyUnlocked,
      ));
    } catch (_) {}
  }
}
