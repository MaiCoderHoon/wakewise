import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/theme/app_animations.dart';
import '../../../../core/constants/theme/app_colors.dart';
import '../../../../core/constants/theme/app_spacing.dart';
import '../../../../core/constants/theme/app_typography.dart';
import '../../../widgets/app_animated_counter.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_fade_slide.dart';
import '../../../widgets/app_primary_button.dart';

/// Premium celebration screen shown when all mission tasks are completed.
/// Features trophy pop-in, confetti burst, XP count-up, and staggered reveal.
class MissionCelebrationView extends StatefulWidget {
  final int totalXpEarned;
  final int newStreak;
  final int newLevel;
  final double levelProgress;

  const MissionCelebrationView({
    super.key,
    required this.totalXpEarned,
    required this.newStreak,
    required this.newLevel,
    required this.levelProgress,
  });

  @override
  State<MissionCelebrationView> createState() => _MissionCelebrationViewState();
}

class _MissionCelebrationViewState extends State<MissionCelebrationView>
    with TickerProviderStateMixin {
  late AnimationController _trophyController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _trophyScale;
  late Animation<double> _confettiProgress;
  late Animation<double> _pulseFactor;

  @override
  void initState() {
    super.initState();

    _trophyController = AnimationController(
      vsync: this,
      duration: AppAnimations.standard,
    );
    _trophyScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _trophyController, curve: AppAnimations.bounce),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _confettiProgress = CurvedAnimation(parent: _confettiController, curve: Curves.easeOut);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseFactor = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _trophyController.forward().then((_) => _confettiController.forward());
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: AppSpacing.paddingAllLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Trophy badge with confetti burst ──────────────
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Confetti burst
                  AnimatedBuilder(
                    animation: _confettiProgress,
                    builder: (context, _) => CustomPaint(
                      size: const Size(180, 180),
                      painter: _CelebrationConfettiPainter(
                        progress: _confettiProgress.value,
                        seed: 99,
                      ),
                    ),
                  ),
                  // Pulsing trophy badge
                  ScaleTransition(
                    scale: _trophyScale,
                    child: ScaleTransition(
                      scale: _pulseFactor,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondary.withValues(alpha: 0.85),
                              AppColors.primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.45),
                              blurRadius: 32,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          size: 68,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.gapH24,

            AppFadeSlide(
              delay: const Duration(milliseconds: 200),
              child: Text(
                '🎉 MORNING QUEST COMPLETE!',
                textAlign: TextAlign.center,
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            AppSpacing.gapH8,
            AppFadeSlide(
              delay: const Duration(milliseconds: 260),
              child: Text(
                'You conquered every stage and defeated morning inertia!',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),

            AppSpacing.gapH24,

            // ── Rewards Breakdown Card ─────────────────────────
            AppFadeSlide(
              delay: const Duration(milliseconds: 340),
              child: AppCard(
                padding: AppSpacing.paddingAllMd,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bolt_rounded, color: Colors.amber, size: 24),
                                const SizedBox(width: 4),
                                AnimatedCounter(
                                  value: widget.totalXpEarned,
                                  prefix: '+',
                                  suffix: ' XP',
                                  style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                                  duration: AppAnimations.slow,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'XP Earned',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Container(height: 40, width: 1, color: AppColors.border),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_fire_department_rounded,
                                    color: Colors.deepOrangeAccent, size: 24),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.newStreak} Days',
                                  style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Morning Streak',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppSpacing.gapH24,
                    const Divider(color: AppColors.border),
                    AppSpacing.gapH12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Level ${widget.newLevel}', style: AppTypography.labelMedium),
                        Text(
                          '${(widget.levelProgress * 100).toInt()}% to Level ${widget.newLevel + 1}',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.secondary),
                        ),
                      ],
                    ),
                    AppSpacing.gapH8,
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: widget.levelProgress),
                      duration: AppAnimations.verySlow,
                      curve: AppAnimations.decelerate,
                      builder: (context, value, _) => ClipRRect(
                        borderRadius: AppSpacing.borderRadiusFull,
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 10,
                          backgroundColor: AppColors.surface,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AppSpacing.gapH32,

            AppFadeSlide(
              delay: const Duration(milliseconds: 420),
              child: AppPrimaryButton(
                label: 'Claim Rewards & Dashboard',
                icon: Icons.home_rounded,
                onPressed: () => context.go('/home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Confetti painter for the celebration burst
class _CelebrationConfettiPainter extends CustomPainter {
  final double progress;
  final int seed;

  _CelebrationConfettiPainter({required this.progress, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final center = Offset(size.width / 2, size.height / 2);

    final colors = [
      AppColors.secondary,
      AppColors.primary,
      AppColors.success,
      Colors.amber,
      Colors.purpleAccent,
    ];

    for (int i = 0; i < 32; i++) {
      final angle = rnd.nextDouble() * 2 * math.pi;
      final maxRadius = 70.0 + rnd.nextDouble() * 25;
      final radius = maxRadius * progress;
      final opacity = (1.0 - progress * 0.9).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final particleSize = 3.0 + rnd.nextDouble() * 5;
      final particleCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle) - radius * 0.25,
      );

      if (i % 3 == 0) {
        canvas.drawCircle(particleCenter, particleSize, paint);
      } else if (i % 3 == 1) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: particleCenter, width: particleSize * 2, height: particleSize),
            const Radius.circular(2),
          ),
          paint,
        );
      } else {
        final path = Path()
          ..moveTo(particleCenter.dx, particleCenter.dy - particleSize)
          ..lineTo(particleCenter.dx + particleSize, particleCenter.dy + particleSize)
          ..lineTo(particleCenter.dx - particleSize, particleCenter.dy + particleSize)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_CelebrationConfettiPainter old) => old.progress != progress;
}
