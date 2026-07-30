import 'dart:math';
import 'package:flutter/material.dart';
import '../../entities/alarm.dart';
import 'base_challenge.dart';
import 'challenge_difficulty.dart';
import 'challenge_result.dart';

/// Memory Sequence Recall Challenge
class MemoryChallenge extends BaseChallenge {
  late List<int> _targetSequence;
  int _attempts = 0;

  MemoryChallenge({
    super.id = 'memory_challenge',
    super.difficulty = ChallengeDifficulty.medium,
  }) : super(
          type: ChallengeType.none, // Custom memory challenge type
          title: 'Memory Challenge',
          description: 'Memorize the tile pattern and repeat it correctly',
          icon: Icons.grid_view_rounded,
        ) {
    initialize();
  }

  List<int> get targetSequence => List.unmodifiable(_targetSequence);
  int get sequenceLength => _targetSequence.length;

  @override
  void initialize() {
    _attempts = 0;
    final random = Random();
    final length = difficulty == ChallengeDifficulty.easy
        ? 3
        : (difficulty == ChallengeDifficulty.medium ? 4 : 5);

    _targetSequence = List.generate(length, (_) => random.nextInt(9) + 1); // Tiles 1-9
  }

  @override
  ChallengeResult evaluate(dynamic payload) {
    _attempts++;
    if (payload is! List<int>) {
      return ChallengeResult(
        status: ChallengeResultStatus.failure,
        message: 'Invalid input sequence',
        attempts: _attempts,
      );
    }

    final userSeq = payload;
    if (userSeq.length != _targetSequence.length) {
      return ChallengeResult(
        status: ChallengeResultStatus.inProgress,
        message: 'Sequence incomplete',
        attempts: _attempts,
      );
    }

    bool isMatch = true;
    for (int i = 0; i < _targetSequence.length; i++) {
      if (userSeq[i] != _targetSequence[i]) {
        isMatch = false;
        break;
      }
    }

    if (isMatch) {
      return ChallengeResult(
        status: ChallengeResultStatus.success,
        message: 'Perfect memory recall! You are fully awake.',
        earnedXp: difficulty.xpMultiplier,
        attempts: _attempts,
      );
    } else {
      return ChallengeResult(
        status: ChallengeResultStatus.failure,
        message: 'Sequence mismatch. Resetting pattern...',
        earnedXp: 0,
        attempts: _attempts,
      );
    }
  }
}
