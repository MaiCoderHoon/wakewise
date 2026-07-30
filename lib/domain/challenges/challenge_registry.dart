import 'dart:math';
import 'entities/base_challenge.dart';
import 'entities/challenge_difficulty.dart';
import 'entities/math_challenge.dart';
import 'entities/memory_challenge.dart';
import 'entities/shake_challenge.dart';

typedef ChallengeBuilder = BaseChallenge Function(ChallengeDifficulty difficulty);

/// Extensible Challenge Factory & Registry
/// Avoids switch statement proliferation by using registered builder function signatures.
class ChallengeRegistry {
  static final ChallengeRegistry _instance = ChallengeRegistry._internal();
  factory ChallengeRegistry() => _instance;

  final Map<String, ChallengeBuilder> _builders = {};

  ChallengeRegistry._internal() {
    _registerDefaultChallenges();
  }

  void _registerDefaultChallenges() {
    registerChallenge('math', (diff) => MathChallenge(difficulty: diff));
    registerChallenge('memory', (diff) => MemoryChallenge(difficulty: diff));
    registerChallenge('shake', (diff) => ShakeChallenge(difficulty: diff));
  }

  /// Register custom challenge type
  void registerChallenge(String key, ChallengeBuilder builder) {
    _builders[key.toLowerCase()] = builder;
  }

  /// Instantiate challenge by key
  BaseChallenge createChallenge(String key, {ChallengeDifficulty difficulty = ChallengeDifficulty.medium}) {
    final builder = _builders[key.toLowerCase()];
    if (builder != null) {
      return builder(difficulty);
    }
    // Default fallback to MathChallenge if unmapped
    return MathChallenge(difficulty: difficulty);
  }

  /// Create a random challenge from registered pool
  BaseChallenge getRandomChallenge({ChallengeDifficulty difficulty = ChallengeDifficulty.medium}) {
    if (_builders.isEmpty) return MathChallenge(difficulty: difficulty);
    final keys = _builders.keys.toList();
    final randomKey = keys[Random().nextInt(keys.length)];
    return createChallenge(randomKey, difficulty: difficulty);
  }

  /// Available registered challenge keys
  List<String> get availableChallengeKeys => List.unmodifiable(_builders.keys);
}
