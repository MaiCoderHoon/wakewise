import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/theme/app_colors.dart';
import '../../../core/constants/theme/app_shadows.dart';
import '../../../core/constants/theme/app_spacing.dart';
import '../../../core/constants/theme/app_typography.dart';
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

            return const Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
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
    return Column(
      children: [
        AppCard.accent(
          child: Column(
            children: [
              Text(
                'MATH MISSION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.secondaryDark,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              AppSpacing.gapH16,
              Text(
                widget.challenge.question,
                style: AppTypography.displayLarge.copyWith(fontSize: 48),
              ),
              AppSpacing.gapH16,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Text(
                  _inputBuffer.isEmpty ? 'Tap digits below...' : _inputBuffer,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineLarge.copyWith(
                    color: _inputBuffer.isEmpty ? AppColors.textMuted : AppColors.textPrimary,
                    fontSize: 28,
                  ),
                ),
              ),
              if (widget.feedbackMessage != null) ...[
                AppSpacing.gapH12,
                Text(
                  widget.feedbackMessage!,
                  style: AppTypography.titleMedium.copyWith(color: AppColors.error),
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
                  _KeypadButton(text: 'C', onTap: _onClear, backgroundColor: AppColors.surfaceSubtle),
                  _KeypadButton(text: '0', onTap: () => _onKeyPress('0')),
                  _KeypadButton(
                    icon: Icons.backspace_outlined,
                    onTap: _onBackspace,
                    backgroundColor: AppColors.surfaceSubtle,
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
    return SizedBox(
      width: 72,
      height: 60,
      child: Material(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.borderRadiusLg,
          splashColor: AppColors.primaryLight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: text != null
                  ? Text(text!, style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold))
                  : Icon(icon, color: AppColors.textPrimary, size: 22),
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
    return Column(
      children: [
        AppCard.accent(
          child: Column(
            children: [
              Text(
                'MEMORY RECALL MISSION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.secondaryDark,
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
                          style: AppTypography.titleMedium.copyWith(color: AppColors.secondaryDark),
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
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: AppShadows.soft,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$n',
                                      style: AppTypography.titleLarge.copyWith(color: AppColors.textOnPrimary),
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
                          style: AppTypography.titleMedium,
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
                                color: idx < _userSequence.length ? AppColors.secondary : AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Center(
                                child: Text(
                                  idx < _userSequence.length ? '${_userSequence[idx]}' : '?',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: idx < _userSequence.length ? Colors.white : AppColors.textMuted,
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
                  style: AppTypography.bodySmall.copyWith(color: AppColors.error),
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
                    color: _showingPreview ? AppColors.surfaceSubtle : AppColors.surface,
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: AppTypography.displaySmall.copyWith(
                        color: _showingPreview ? AppColors.textMuted : AppColors.textPrimary,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppCard.accent(
          child: Column(
            children: [
              Text(
                'SHAKE MISSION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.secondaryDark,
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
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.vibration_rounded, size: 48, color: AppColors.secondary),
                      AppSpacing.gapH8,
                      Text(
                        '${(challenge.progress * 100).toInt()}%',
                        style: AppTypography.displayMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${challenge.currentShakes} / ${challenge.targetShakes}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),

              AppSpacing.gapH24,
              Text(
                'Shake your device vigorously!',
                style: AppTypography.titleLarge,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: AppShadows.floating,
          ),
          child: const Center(
            child: Icon(Icons.emoji_events_rounded, size: 72, color: AppColors.textOnPrimary),
          ),
        ),
        AppSpacing.gapH32,

        Text(
          'Mission Accomplished!',
          style: AppTypography.displaySmall,
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapH8,
        Text(
          result.message.isNotEmpty ? result.message : 'You are wide awake and energized!',
          style: AppTypography.bodyLarge,
          textAlign: TextAlign.center,
        ),

        AppSpacing.gapH24,

        AppCard.accent(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppColors.secondary, size: 28),
                  AppSpacing.gapH4,
                  Text('+${result.earnedXp} XP', style: AppTypography.titleLarge),
                  Text('Reward', style: AppTypography.bodySmall),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 28),
                  AppSpacing.gapH4,
                  Text('${result.attempts}', style: AppTypography.titleLarge),
                  Text('Attempts', style: AppTypography.bodySmall),
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
