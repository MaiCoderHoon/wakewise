import '../challenges/entities/base_challenge.dart';

/// Represents an individual task step in a Morning Quest
class MissionTask {
  final String id;
  final String title;
  final String description;
  final BaseChallenge challenge;
  final int xpReward;
  final bool isCompleted;

  const MissionTask({
    required this.id,
    required this.title,
    required this.description,
    required this.challenge,
    this.xpReward = 25,
    this.isCompleted = false,
  });

  MissionTask copyWith({
    String? id,
    String? title,
    String? description,
    BaseChallenge? challenge,
    int? xpReward,
    bool? isCompleted,
  }) {
    return MissionTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      challenge: challenge ?? this.challenge,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
