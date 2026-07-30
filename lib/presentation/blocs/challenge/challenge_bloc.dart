import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/challenges/challenge_registry.dart';
import '../../../domain/challenges/entities/base_challenge.dart';
import 'challenge_event.dart';
import 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRegistry registry;
  BaseChallenge? _activeChallenge;

  ChallengeBloc({ChallengeRegistry? registry})
      : registry = registry ?? ChallengeRegistry(),
        super(const ChallengeInitial()) {
    on<StartChallenge>(_onStartChallenge);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<RetryChallenge>(_onRetryChallenge);
    on<CompleteChallenge>(_onCompleteChallenge);
  }

  void _onStartChallenge(StartChallenge event, Emitter<ChallengeState> emit) {
    if (event.challengeKey.toLowerCase() == 'random') {
      _activeChallenge = registry.getRandomChallenge(difficulty: event.difficulty);
    } else {
      _activeChallenge = registry.createChallenge(event.challengeKey, difficulty: event.difficulty);
    }

    _activeChallenge!.initialize();

    emit(ChallengeInProgress(
      challenge: _activeChallenge!,
      attemptCount: 0,
    ));
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<ChallengeState> emit) {
    if (_activeChallenge == null) return;

    final result = _activeChallenge!.evaluate(event.payload);

    if (result.isSuccess) {
      emit(ChallengeSuccess(
        challenge: _activeChallenge!,
        result: result,
      ));
    } else if (result.isFailure) {
      final currentAttempts = (state is ChallengeInProgress)
          ? (state as ChallengeInProgress).attemptCount + 1
          : 1;

      emit(ChallengeInProgress(
        challenge: _activeChallenge!,
        feedbackMessage: result.message.isNotEmpty ? result.message : 'Try again!',
        attemptCount: currentAttempts,
      ));
    } else {
      // inProgress state update (e.g. shake step or partial memory sequence)
      emit(ChallengeInProgress(
        challenge: _activeChallenge!,
        feedbackMessage: result.message,
        attemptCount: (state is ChallengeInProgress)
            ? (state as ChallengeInProgress).attemptCount
            : 0,
      ));
    }
  }

  void _onRetryChallenge(RetryChallenge event, Emitter<ChallengeState> emit) {
    if (_activeChallenge != null) {
      _activeChallenge!.initialize();
      emit(ChallengeInProgress(
        challenge: _activeChallenge!,
        attemptCount: 0,
      ));
    }
  }

  void _onCompleteChallenge(CompleteChallenge event, Emitter<ChallengeState> emit) {
    emit(const ChallengeInitial());
  }
}
