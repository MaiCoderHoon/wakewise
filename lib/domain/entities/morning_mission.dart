import 'mission_task.dart';

/// Represents a multi-stage Morning Quest mission session
class MorningMission {
  final String id;
  final String title;
  final List<MissionTask> tasks;
  final int currentTaskIndex;
  final bool isCompleted;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const MorningMission({
    required this.id,
    required this.title,
    required this.tasks,
    this.currentTaskIndex = 0,
    this.isCompleted = false,
    this.startedAt,
    this.completedAt,
  });

  /// The active task currently being performed
  MissionTask? get currentTask =>
      (currentTaskIndex >= 0 && currentTaskIndex < tasks.length)
          ? tasks[currentTaskIndex]
          : null;

  /// Quest progress percentage from 0.0 to 1.0
  double get progress {
    if (tasks.isEmpty) return 0.0;
    if (isCompleted) return 1.0;
    return (currentTaskIndex / tasks.length).clamp(0.0, 1.0);
  }

  /// Total XP possible upon completing all tasks in mission
  int get totalXpReward => tasks.fold(0, (sum, t) => sum + t.xpReward);

  /// Total XP earned from already completed tasks
  int get earnedXp => tasks.take(currentTaskIndex).fold(0, (sum, t) => sum + t.xpReward);

  /// Check if active task is the final step
  bool get isLastTask => currentTaskIndex == tasks.length - 1;

  MorningMission copyWith({
    String? id,
    String? title,
    List<MissionTask>? tasks,
    int? currentTaskIndex,
    bool? isCompleted,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return MorningMission(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
      currentTaskIndex: currentTaskIndex ?? this.currentTaskIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
