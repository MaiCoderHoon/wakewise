import 'dart:math';
import 'package:flutter/material.dart';
import '../../entities/alarm.dart';
import 'base_challenge.dart';
import 'challenge_difficulty.dart';
import 'challenge_result.dart';

/// Math Challenge Implementation
class MathChallenge extends BaseChallenge {
  late String _question;
  late int _correctAnswer;
  int _attempts = 0;

  MathChallenge({
    super.id = 'math_challenge',
    super.difficulty = ChallengeDifficulty.medium,
  }) : super(
          type: ChallengeType.math,
          title: 'Math Challenge',
          description: 'Solve arithmetic equations to turn off the alarm',
          icon: Icons.calculate_rounded,
        ) {
    initialize();
  }

  String get question => _question;
  int get correctAnswer => _correctAnswer;

  @override
  void initialize() {
    _attempts = 0;
    final random = Random();

    switch (difficulty) {
      case ChallengeDifficulty.easy:
        final a = random.nextInt(15) + 2;
        final b = random.nextInt(15) + 2;
        _question = '$a + $b';
        _correctAnswer = a + b;
        break;
      case ChallengeDifficulty.medium:
        final op = random.nextBool(); // true = +, false = *
        if (op) {
          final a = random.nextInt(40) + 15;
          final b = random.nextInt(40) + 15;
          _question = '$a + $b';
          _correctAnswer = a + b;
        } else {
          final a = random.nextInt(12) + 3;
          final b = random.nextInt(9) + 3;
          _question = '$a × $b';
          _correctAnswer = a * b;
        }
        break;
      case ChallengeDifficulty.hard:
        final a = random.nextInt(50) + 20;
        final b = random.nextInt(50) + 20;
        final c = random.nextInt(30) + 10;
        _question = '$a + $b - $c';
        _correctAnswer = a + b - c;
        break;
    }
  }

  @override
  ChallengeResult evaluate(dynamic payload) {
    _attempts++;
    final int? userAnswer = int.tryParse(payload.toString());

    if (userAnswer == _correctAnswer) {
      return ChallengeResult(
        status: ChallengeResultStatus.success,
        message: 'Correct answer! Morning brain unlocked.',
        earnedXp: difficulty.xpMultiplier,
        attempts: _attempts,
      );
    } else {
      return ChallengeResult(
        status: ChallengeResultStatus.failure,
        message: 'Incorrect answer. Try again!',
        earnedXp: 0,
        attempts: _attempts,
      );
    }
  }
}
