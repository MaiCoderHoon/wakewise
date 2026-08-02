import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/theme/app_spacing.dart';
import '../../../domain/challenges/entities/base_challenge.dart';
import '../../../domain/challenges/entities/challenge_difficulty.dart';
import '../../../domain/challenges/entities/challenge_result.dart';
import '../../../domain/challenges/entities/math_challenge.dart';
import '../../../domain/challenges/entities/memory_challenge.dart';
import '../../../domain/challenges/entities/shake_challenge.dart';
import '../../blocs/challenge/challenge_bloc.dart';
import '../../blocs/challenge/challenge_event.dart';
import '../../blocs/challenge/challenge_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/app_primary_button.dart';

/// Screen hosting active challenge execution
class ChallengePlayScreen extends StatefulWidget {
  final String challengeKey;
  final ChallengeDifficulty difficulty;

  const ChallengePlayScreen({
    super.key,
    required this.challengeKey,
    this.difficulty = ChallengeDifficulty.medium,
  });

  @override
  State<ChallengePlayScreen> createState() => _ChallengePlayScreenState();
}

class _ChallengePlayScreenState extends State<ChallengePlayScreen> {
  late ChallengeBloc _challengeBloc;

  @override
  void initState() {
    super.initState();
    _challengeBloc = ChallengeBloc();
    _challengeBloc.add(StartChallenge(
      challengeKey: widget.challengeKey,
      difficulty: widget.difficulty,
    ));
  }

  @override
  void dispose() {
    _challengeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _challengeBloc,
      child: AppPageScaffold(
        isScrollable: false,
        appBar: AppBar(
          title: const Text('Wake-Up Mission'),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.pop(false),
          ),
        ),
        body: BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (context, state) {
            if (state is ChallengeInProgress) {
              final challenge = state.challenge;

              if (challenge is MathChallenge) {
                return _MathChallengeView(
                  challenge: challenge,
                  feedbackMessage: state.feedbackMessage,
                );
              } else if (challenge is MemoryChallenge) {
                return _MemoryChallengeView(
                  challenge: challenge,
                  feedbackMessage: state.feedbackMessage,
                );
              } else if (challenge is ShakeChallenge) {
                return _ShakeChallengeView(
                  challenge: challenge,
                  feedbackMessage: state.feedbackMessage,
                );
              }
            }

            if (state is ChallengeSuccess) {
              return _ChallengeSuccessView(
                challenge: state.challenge,
                result: state.result,
              );
            }

            return Center(
              child: CircularProgressIndicator(color: theme.colorScheme.primary),
            );
          },
        ),
      ),
    );
  }
}

/// Math Challenge View
class _MathChallengeView extends StatefulWidget {
  final MathChallenge challenge;
  final String? feedbackMessage;

  const _MathChallengeView({
    required this.challenge,
    this.feedbackMessage,
  });

  @override
  State<_MathChallengeView> createState() => _MathChallengeViewState();
}

class _MathChallengeViewState extends State<_MathChallengeView> {
  String _inputBuffer = '';

  void _onKeyPress(String val) {
    if (_inputBuffer.length < 5) {
      setState(() => _inputBuffer += val);
    }
  }

  void _onBackspace() {
    if (_inputBuffer.isNotEmpty) {
      setState(() => _inputBuffer = _inputBuffer.substring(0, _inputBuffer.length - 1));
    }
  }

  void _onClear() {
    setState(() => _inputBuffer = '');
  }

  void _onSubmit() {
    if (_inputBuffer.isNotEmpty) {
      context.read<ChallengeBloc>().add(SubmitAnswer(_inputBuffer));
      _onClear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: [
        AppCard.accent(
          child: Column(
            children: [
              Text(
                'MATH MISSION',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              AppSpacing.gapH16,
              Text(
                widget.challenge.question,
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 48),
              ),
              AppSpacing.gapH16,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _inputBuffer.isEmpty ? 'Tap digits below...' : _inputBuffer,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: _inputBuffer.isEmpty
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                        : theme.colorScheme.onSurface,
                    fontSize: 28,
                  ),
                ),
              ),
              if (widget.feedbackMessage != null) ...[
                AppSpacing.gapH12,
                Text(
                  widget.feedbackMessage!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),

        AppSpacing.gapH24,

        // Numeric Keypad
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['1', '2', '3'].map((digit) => _KeypadButton(text: digit, onTap: () => _onKeyPress(digit))).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['4', '5', '6'].map((digit) => _KeypadButton(text: digit, onTap: () => _onKeyPress(digit))).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['7', '8', '9'].map((digit) => _KeypadButton(text: digit, onTap: () => _onKeyPress(digit))).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _KeypadButton(
                    text: 'C',
                    onTap: _onClear,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                  ),
                  _KeypadButton(text: '0', onTap: () => _onKeyPress('0')),
                  _KeypadButton(
                    icon: Icons.backspace_outlined,
                    onTap: _onBackspace,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                  ),
                ],
              ),
            ],
          ),
        ),

        AppSpacing.gapH16,

        AppPrimaryButton(
          label: 'Submit Answer',
          icon: Icons.check_rounded,
          onPressed: _inputBuffer.isEmpty ? null : _onSubmit,
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const _KeypadButton({
    this.text,
    this.icon,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 72,
      height: 60,
      child: Material(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.borderRadiusLg,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
            child: Center(
              child: text != null
                  ? Text(
                      text!,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Icon(icon, color: theme.colorScheme.onSurface, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

/// Memory Challenge View
class _MemoryChallengeView extends StatefulWidget {
  final MemoryChallenge challenge;
  final String? feedbackMessage;

  const _MemoryChallengeView({
    required this.challenge,
    this.feedbackMessage,
  });

  @override
  State<_MemoryChallengeView> createState() => _MemoryChallengeViewState();
}

class _MemoryChallengeViewState extends State<_MemoryChallengeView> {
  bool _showingPreview = true;
  int _previewCountdown = 3;
  Timer? _previewTimer;
  final List<int> _userSequence = [];

  @override
  void initState() {
    super.initState();
    _startPreviewTimer();
  }

  void _startPreviewTimer() {
    _showingPreview = true;
    _previewCountdown = 3;
    _userSequence.clear();

    _previewTimer?.cancel();
    _previewTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_previewCountdown > 1) {
        setState(() => _previewCountdown--);
      } else {
        timer.cancel();
        if (mounted) {
          setState(() => _showingPreview = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    super.dispose();
  }

  void _onTileTap(int number) {
    if (_showingPreview) return;

    setState(() => _userSequence.add(number));

    if (_userSequence.length == widget.challenge.sequenceLength) {
      context.read<ChallengeBloc>().add(SubmitAnswer(List<int>.from(_userSequence)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: [
        AppCard.accent(
          child: Column(
            children: [
              Text(
                'MEMORY RECALL MISSION',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              AppSpacing.gapH12,
              _showingPreview
                  ? Column(
                      children: [
                        Text(
                          'Memorize Pattern in $_previewCountdown s',
                          style: theme.textTheme.titleMedium?.copyWith(color: primaryColor),
                        ),
                        AppSpacing.gapH12,
                        Wrap(
                          spacing: 12,
                          children: widget.challenge.targetSequence
                              .map(
                                (n) => Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$n',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          'Tap tiles in sequence (${_userSequence.length}/${widget.challenge.sequenceLength})',
                          style: theme.textTheme.titleMedium,
                        ),
                        AppSpacing.gapH12,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.challenge.sequenceLength,
                            (idx) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: idx < _userSequence.length
                                    ? primaryColor
                                    : theme.colorScheme.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  idx < _userSequence.length ? '${_userSequence[idx]}' : '?',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: idx < _userSequence.length
                                        ? Colors.white
                                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              if (widget.feedbackMessage != null && !_showingPreview) ...[
                AppSpacing.gapH12,
                Text(
                  widget.feedbackMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                ),
              ],
            ],
          ),
        ),

        AppSpacing.gapH24,

        // 3x3 Tile Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final number = index + 1;
              return GestureDetector(
                onTap: () => _onTileTap(number),
                child: Container(
                  decoration: BoxDecoration(
                    color: _showingPreview
                        ? primaryColor.withValues(alpha: 0.1)
                        : theme.colorScheme.surface,
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: _showingPreview
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        if (!_showingPreview)
          TextButton.icon(
            onPressed: _startPreviewTimer,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Re-play Pattern'),
          ),
      ],
    );
  }
}

/// Shake Challenge View
class _ShakeChallengeView extends StatelessWidget {
  final ShakeChallenge challenge;
  final String? feedbackMessage;

  const _ShakeChallengeView({
    required this.challenge,
    this.feedbackMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppCard.accent(
          child: Column(
            children: [
              Text(
                'SHAKE MISSION',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              AppSpacing.gapH24,

              // Animated Circular Progress Ring
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: challenge.progress,
                      strokeWidth: 14,
                      backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.vibration_rounded, size: 48, color: primaryColor),
                      AppSpacing.gapH8,
                      Text(
                        '${(challenge.progress * 100).toInt()}%',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${challenge.currentShakes} / ${challenge.targetShakes}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),

              AppSpacing.gapH24,
              Text(
                'Shake your device vigorously!',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        AppSpacing.gapH32,

        // Simulator Tap / Shake Button
        AppPrimaryButton(
          label: 'SIMULATE SHAKE (+3)',
          icon: Icons.vibration_rounded,
          onPressed: () {
            context.read<ChallengeBloc>().add(const SubmitAnswer(3));
          },
        ),
      ],
    );
  }
}

/// Challenge Success View
class _ChallengeSuccessView extends StatelessWidget {
  final BaseChallenge challenge;
  final ChallengeResult result;

  const _ChallengeSuccessView({
    required this.challenge,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [primaryColor, theme.colorScheme.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.4),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.emoji_events_rounded, size: 72, color: Colors.white),
          ),
        ),
        AppSpacing.gapH32,

        Text(
          'Mission Accomplished!',
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapH8,
        Text(
          result.message.isNotEmpty ? result.message : 'You are wide awake and energized!',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),

        AppSpacing.gapH24,

        AppCard.accent(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(Icons.bolt_rounded, color: primaryColor, size: 28),
                  AppSpacing.gapH4,
                  Text('+${result.earnedXp} XP', style: theme.textTheme.titleLarge),
                  Text('Reward', style: theme.textTheme.bodySmall),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.check_circle_outline_rounded, color: theme.colorScheme.primary, size: 28),
                  AppSpacing.gapH4,
                  Text('${result.attempts}', style: theme.textTheme.titleLarge),
                  Text('Attempts', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),

        AppSpacing.gapH48,

        AppPrimaryButton(
          label: 'Complete Mission',
          icon: Icons.check_rounded,
          onPressed: () {
            context.pop(true);
          },
        ),
      ],
    );
  }
}
