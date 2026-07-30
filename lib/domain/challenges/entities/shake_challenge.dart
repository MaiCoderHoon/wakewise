import 'package:flutter/material.dart';
import '../../entities/alarm.dart';
import 'base_challenge.dart';
import 'challenge_difficulty.dart';
import 'challenge_result.dart';

/// Phone Shake Motion Challenge
class ShakeChallenge extends BaseChallenge {
  late int _targetShakes;
  int _currentShakes = 0;

  ShakeChallenge({
    super.id = 'shake_challenge',
    super.difficulty = ChallengeDifficulty.medium,
  }) : super(
          type: ChallengeType.shake,
          title: 'Shake Challenge',
          description: 'Vigorously shake your phone until the progress bar reaches 100%',
          icon: Icons.vibration_rounded,
        ) {
    initialize();
  }

  int get targetShakes => _targetShakes;
  int get currentShakes => _currentShakes;
  double get progress => (_currentShakes / _targetShakes).clamp(0.0, 1.0);

  @override
  void initialize() {
    _currentShakes = 0;
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        _targetShakes = 15;
        break;
      case ChallengeDifficulty.medium:
        _targetShakes = 30;
        break;
      case ChallengeDifficulty.hard:
        _targetShakes = 50;
        break;
    }
  }

  /// Step payload: number of shakes to add (e.g. 1 per shake event or step)
  @override
  ChallengeResult evaluate(dynamic payload) {
    final int countToAdd = (payload as int?) ?? 1;
    _currentShakes += countToAdd;

    if (_currentShakes >= _targetShakes) {
      _currentShakes = _targetShakes;
      return ChallengeResult(
        status: ChallengeResultStatus.success,
        message: 'Physical movement target reached! Wake-up complete.',
        earnedXp: difficulty.xpMultiplier,
        attempts: 1,
      );
    }

    return ChallengeResult(
      status: ChallengeResultStatus.inProgress,
      message: '$_currentShakes / $_targetShakes Shakes',
      earnedXp: 0,
      attempts: 1,
    );
  }
}
