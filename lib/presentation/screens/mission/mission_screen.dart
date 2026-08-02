import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/theme/app_animations.dart';

import '../../../../core/constants/theme/app_spacing.dart';
import '../../../../domain/challenges/entities/challenge_difficulty.dart';
import '../../../../domain/challenges/entities/math_challenge.dart';
import '../../../../domain/challenges/entities/memory_challenge.dart';
import '../../../../domain/challenges/entities/shake_challenge.dart';
import '../../blocs/mission/mission_bloc.dart';
import '../../blocs/mission/mission_event.dart';
import '../../blocs/mission/mission_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/app_primary_button.dart';
import 'widgets/mission_celebration_view.dart';
import 'widgets/mission_progress_header.dart';
import 'widgets/upcoming_tasks_list.dart';

class MissionScreen extends StatefulWidget {
  final ChallengeDifficulty difficulty;

  const MissionScreen({
    super.key,
    this.difficulty = ChallengeDifficulty.medium,
  });

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  late MissionBloc _missionBloc;

  @override
  void initState() {
    super.initState();
    _missionBloc = MissionBloc();
    _missionBloc.add(StartMorningMission(difficulty: widget.difficulty));
  }

  @override
  void dispose() {
    _missionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _missionBloc,
      child: AppPageScaffold(
        isScrollable: false,
        appBar: AppBar(
          title: const Text('🌅 Morning Quest'),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<MissionBloc, MissionState>(
          listener: (context, state) {
            if (state is MissionTaskSuccess) {
              HapticFeedback.heavyImpact();
              _showSuccessBanner(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is MissionCelebrationState) {
              return MissionCelebrationView(
                totalXpEarned: state.totalXpEarned,
                newStreak: state.newStreak,
                newLevel: state.newLevel,
                levelProgress: state.levelProgress,
              );
            }

            if (state is MissionInProgress || state is MissionTaskSuccess) {
              final mission = (state is MissionInProgress)
                  ? state.mission
                  : (state as MissionTaskSuccess).mission;
              final feedbackMessage = (state is MissionInProgress) ? state.feedbackMessage : null;
              final currentTask = mission.currentTask;

              if (currentTask == null) return const SizedBox.shrink();

              return Column(
                children: [
                  MissionProgressHeader(mission: mission),
                  AppSpacing.gapH12,
                  UpcomingTasksList(mission: mission),
                  AppSpacing.gapH16,
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: AppAnimations.standard,
                      transitionBuilder: (child, animation) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: AppAnimations.enterCurve,
                        );
                        return FadeTransition(
                          opacity: curved,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey(currentTask.id),
                        child: _buildTaskView(context, currentTask.challenge, feedbackMessage),
                      ),
                    ),
                  ),
                ],
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

  /// Shows a transient success banner overlay at the top of the screen
  void _showSuccessBanner(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _SuccessBannerOverlay(
        message: message,
        onDismissed: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }

  Widget _buildTaskView(BuildContext context, dynamic challenge, String? feedbackMessage) {
    if (challenge is MathChallenge) {
      return _MathMissionTaskView(
        challenge: challenge,
        feedbackMessage: feedbackMessage,
      );
    } else if (challenge is MemoryChallenge) {
      return _MemoryMissionTaskView(
        challenge: challenge,
        feedbackMessage: feedbackMessage,
      );
    } else if (challenge is ShakeChallenge) {
      return _ShakeMissionTaskView(
        challenge: challenge,
        feedbackMessage: feedbackMessage,
      );
    }

    return const Center(child: Text('Unsupported Challenge Type'));
  }
}

/// Math Task Interactive View
class _MathMissionTaskView extends StatefulWidget {
  final MathChallenge challenge;
  final String? feedbackMessage;

  const _MathMissionTaskView({
    required this.challenge,
    this.feedbackMessage,
  });

  @override
  State<_MathMissionTaskView> createState() => _MathMissionTaskViewState();
}

class _MathMissionTaskViewState extends State<_MathMissionTaskView> {
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
      HapticFeedback.mediumImpact();
      context.read<MissionBloc>().add(SubmitTaskAnswer(_inputBuffer));
      _onClear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCard.accent(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        Text(
                          'STAGE 1: QUICK MATH',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        AppSpacing.gapH8,
                        Text(
                          widget.challenge.question,
                          style: theme.textTheme.displayLarge?.copyWith(fontSize: 34),
                        ),
                        AppSpacing.gapH8,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: AppSpacing.borderRadiusSm,
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _inputBuffer.isEmpty ? 'Tap numbers below...' : _inputBuffer,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: _inputBuffer.isEmpty
                                  ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                                  : theme.colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        if (widget.feedbackMessage != null) ...[
                          AppSpacing.gapH8,
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
                  AppSpacing.gapH12,
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['1', '2', '3'].map((digit) => _KeypadBtn(text: digit, onTap: () => _onKeyPress(digit))).toList(),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['4', '5', '6'].map((digit) => _KeypadBtn(text: digit, onTap: () => _onKeyPress(digit))).toList(),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['7', '8', '9'].map((digit) => _KeypadBtn(text: digit, onTap: () => _onKeyPress(digit))).toList(),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _KeypadBtn(
                            text: 'C',
                            onTap: _onClear,
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                          ),
                          _KeypadBtn(text: '0', onTap: () => _onKeyPress('0')),
                          _KeypadBtn(
                            icon: Icons.backspace_outlined,
                            onTap: _onBackspace,
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppSpacing.gapH12,
                  AppPrimaryButton(
                    label: 'Submit Stage 1',
                    icon: Icons.check_rounded,
                    onPressed: _inputBuffer.isEmpty ? null : _onSubmit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _KeypadBtn extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const _KeypadBtn({
    this.text,
    this.icon,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        width: 64,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        child: Center(
          child: text != null
              ? Text(
                  text!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Icon(icon, color: theme.colorScheme.onSurface, size: 20),
        ),
      ),
    );
  }
}

/// Memory Task Interactive View
class _MemoryMissionTaskView extends StatefulWidget {
  final MemoryChallenge challenge;
  final String? feedbackMessage;

  const _MemoryMissionTaskView({
    required this.challenge,
    this.feedbackMessage,
  });

  @override
  State<_MemoryMissionTaskView> createState() => _MemoryMissionTaskViewState();
}

class _MemoryMissionTaskViewState extends State<_MemoryMissionTaskView> {
  bool _isMemorizePhase = true;
  Timer? _memorizeTimer;
  final List<int> _userSelectedSequence = [];

  @override
  void initState() {
    super.initState();
    _startMemorizePhase();
  }

  void _startMemorizePhase() {
    _isMemorizePhase = true;
    _memorizeTimer?.cancel();
    _memorizeTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isMemorizePhase = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _memorizeTimer?.cancel();
    super.dispose();
  }

  void _onTileTap(int tileNum) {
    if (_isMemorizePhase) return;

    setState(() {
      _userSelectedSequence.add(tileNum);
    });

    if (_userSelectedSequence.length == widget.challenge.sequenceLength) {
      context.read<MissionBloc>().add(SubmitTaskAnswer(List<int>.from(_userSelectedSequence)));
      _userSelectedSequence.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final targetSeq = widget.challenge.targetSequence;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCard.accent(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        Text(
                          'STAGE 2: PATTERN RECALL',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        AppSpacing.gapH8,
                        Text(
                          _isMemorizePhase
                              ? 'Sequence: ${targetSeq.join(" - ")}'
                              : 'Tap tiles 1-9 in order (${_userSelectedSequence.length}/${widget.challenge.sequenceLength})',
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        if (widget.feedbackMessage != null) ...[
                          AppSpacing.gapH8,
                          Text(
                            widget.feedbackMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AppSpacing.gapH16,
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final tileNum = index + 1;
                      final isTarget = targetSeq.contains(tileNum);

                      Color tileColor = theme.colorScheme.surface;
                      if (_isMemorizePhase && isTarget) {
                        tileColor = primaryColor;
                      } else if (_userSelectedSequence.contains(tileNum)) {
                        tileColor = primaryColor.withValues(alpha: 0.3);
                      }

                      return InkWell(
                        onTap: () => _onTileTap(tileNum),
                        borderRadius: AppSpacing.borderRadiusMd,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: tileColor,
                            borderRadius: AppSpacing.borderRadiusMd,
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$tileNum',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: (_isMemorizePhase && isTarget)
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AppSpacing.gapH16,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Shake Task Interactive View
class _ShakeMissionTaskView extends StatelessWidget {
  final ShakeChallenge challenge;
  final String? feedbackMessage;

  const _ShakeMissionTaskView({
    required this.challenge,
    this.feedbackMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final progress = challenge.progress;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCard.accent(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        Text(
                          'STAGE 3: ENERGY SHAKE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        AppSpacing.gapH8,
                        Text(
                          'Shake your device to reach 100%',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapH16,
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<MissionBloc>().add(const SubmitTaskAnswer(5));
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withValues(alpha: 0.15),
                              border: Border.all(color: primaryColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: (0.4 * progress).clamp(0.0, 1.0)),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.vibration_rounded,
                              size: 56,
                              color: Color.lerp(
                                theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                primaryColor,
                                progress,
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.gapH16,
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          '${challenge.currentShakes} / ${challenge.targetShakes} Shakes',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          '(Tap icon above or shake phone to trigger)',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapH16,
                  AppPrimaryButton(
                    label: 'Shake Device (+5 Shakes)',
                    icon: Icons.vibration_rounded,
                    onPressed: () {
                      context.read<MissionBloc>().add(const SubmitTaskAnswer(5));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// In-screen success banner overlay — flies in from top, auto-dismisses after 900ms
class _SuccessBannerOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const _SuccessBannerOverlay({required this.message, required this.onDismissed});

  @override
  State<_SuccessBannerOverlay> createState() => _SuccessBannerOverlayState();
}

class _SuccessBannerOverlayState extends State<_SuccessBannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.fast,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.enterCurve));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.forward();
      _dismissTimer = Timer(const Duration(milliseconds: 900), () {
        if (mounted) {
          _controller.reverse().then((_) => widget.onDismissed());
        }
      });
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: AppSpacing.borderRadiusLg,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Text(
                      widget.message,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
