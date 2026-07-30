import 'package:flutter/material.dart';
import '../../entities/alarm.dart';
import 'challenge_difficulty.dart';
import 'challenge_result.dart';

/// Abstract contract for all wake-up challenges in WakeWise
abstract class BaseChallenge {
  final String id;
  final ChallengeType type;
  final String title;
  final String description;
  final IconData icon;
  final ChallengeDifficulty difficulty;

  BaseChallenge({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    this.difficulty = ChallengeDifficulty.medium,
  });

  /// Initialize / reset problem state for a new session
  void initialize();

  /// Evaluate payload answer input
  ChallengeResult evaluate(dynamic payload);
}
