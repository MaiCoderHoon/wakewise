import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/challenges/entities/math_challenge.dart';
import '../../../domain/challenges/entities/memory_challenge.dart';
import '../../../domain/challenges/entities/shake_challenge.dart';
import '../../../domain/entities/mission_task.dart';
import '../../../domain/entities/morning_mission.dart';
import 'mission_event.dart';
import 'mission_state.dart';

class MissionBloc extends Bloc<MissionEvent, MissionState> {
  MorningMission? _activeMission;

  MissionBloc() : super(const MissionInitial()) {
    on<StartMorningMission>(_onStartMorningMission);
    on<SubmitTaskAnswer>(_onSubmitTaskAnswer);
    on<AdvanceToNextTask>(_onAdvanceToNextTask);
    on<CompleteMissionEvent>(_onCompleteMissionEvent);
  }

  void _onStartMorningMission(
    StartMorningMission event,
    Emitter<MissionState> emit,
  ) {
    final diff = event.difficulty;

    // Default 3-stage Morning Quest: Math -> Memory -> Shake
    final task1Challenge = MathChallenge(difficulty: diff);
    final task2Challenge = MemoryChallenge(difficulty: diff);
    final task3Challenge = ShakeChallenge(difficulty: diff);

    task1Challenge.initialize();
    task2Challenge.initialize();
    task3Challenge.initialize();

    final tasks = [
      MissionTask(
        id: 'task_math',
        title: 'Stage 1: Quick Math',
        description: 'Solve the equation to kickstart your brain logic.',
        challenge: task1Challenge,
        xpReward: 25,
      ),
      MissionTask(
        id: 'task_memory',
        title: 'Stage 2: Pattern Recall',
        description: 'Memorize & repeat the tile sequence.',
        challenge: task2Challenge,
        xpReward: 35,
      ),
      MissionTask(
        id: 'task_shake',
        title: 'Stage 3: Energy Shake',
        description: 'Vigorously shake your device to boost alertness.',
        challenge: task3Challenge,
        xpReward: 40,
      ),
    ];

    _activeMission = MorningMission(
      id: 'mission_${DateTime.now().millisecondsSinceEpoch}',
      title: '🌅 Morning Quest',
      tasks: tasks,
      currentTaskIndex: 0,
      startedAt: DateTime.now(),
    );

    emit(MissionInProgress(mission: _activeMission!));
  }

  Future<void> _onSubmitTaskAnswer(
    SubmitTaskAnswer event,
    Emitter<MissionState> emit,
  ) async {
    if (_activeMission == null || _activeMission!.currentTask == null) return;

    final currentTask = _activeMission!.currentTask!;
    final result = currentTask.challenge.evaluate(event.payload);

    if (result.isSuccess) {
      // Mark current task as completed
      final updatedTasks = List<MissionTask>.from(_activeMission!.tasks);
      updatedTasks[_activeMission!.currentTaskIndex] = currentTask.copyWith(isCompleted: true);

      _activeMission = _activeMission!.copyWith(tasks: updatedTasks);

      emit(MissionTaskSuccess(
        mission: _activeMission!,
        completedTask: currentTask,
        message: result.message.isNotEmpty ? result.message : 'Stage Cleared! 🎉',
      ));

      // Wait briefly for completion animation feedback
      await Future.delayed(const Duration(milliseconds: 600));

      if (_activeMission!.isLastTask) {
        add(const CompleteMissionEvent());
      } else {
        add(const AdvanceToNextTask());
      }
    } else if (result.isFailure) {
      emit(MissionInProgress(
        mission: _activeMission!,
        feedbackMessage: result.message.isNotEmpty ? result.message : 'Incorrect, try again!',
      ));
    } else {
      // In-progress partial step (e.g. progress count in Shake challenge)
      emit(MissionInProgress(
        mission: _activeMission!,
        feedbackMessage: result.message,
      ));
    }
  }

  void _onAdvanceToNextTask(
    AdvanceToNextTask event,
    Emitter<MissionState> emit,
  ) {
    if (_activeMission == null) return;

    final nextIndex = _activeMission!.currentTaskIndex + 1;
    if (nextIndex < _activeMission!.tasks.length) {
      _activeMission = _activeMission!.copyWith(currentTaskIndex: nextIndex);
      _activeMission!.currentTask?.challenge.initialize();

      emit(MissionInProgress(
        mission: _activeMission!,
        isTaskTransitioning: true,
      ));
    } else {
      add(const CompleteMissionEvent());
    }
  }

  void _onCompleteMissionEvent(
    CompleteMissionEvent event,
    Emitter<MissionState> emit,
  ) {
    if (_activeMission == null) return;

    final finalMission = _activeMission!.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    final totalXp = finalMission.totalXpReward;

    emit(MissionCelebrationState(
      mission: finalMission,
      totalXpEarned: totalXp,
      newStreak: 3,
      newLevel: 5,
      levelProgress: 0.75,
    ));
  }
}
