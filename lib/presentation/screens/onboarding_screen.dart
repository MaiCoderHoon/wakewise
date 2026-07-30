import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_shadows.dart';
import '../../core/constants/theme/app_spacing.dart';
import '../../core/constants/theme/app_typography.dart';
import '../widgets/app_card.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/app_primary_button.dart';

/// WakeWise Onboarding Screen
/// 3-page swipeable walkthrough introducing WakeWise features, challenge alarms, and habit tracking.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSkipPressed() {
    context.go('/home');
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      isScrollable: false,
      applySafeArea: true,
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          // Header with Skip Button on every page
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Mini Logo indicator
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_rounded, color: AppColors.secondary, size: 24),
                    AppSpacing.gapW8,
                    Text(
                      'WakeWise',
                      style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
                // Skip Button
                TextButton(
                  onPressed: _onSkipPressed,
                  child: Text(
                    'Skip',
                    style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          // Swipeable PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                const _OnboardingPageOne(),
                const _OnboardingPageTwo(),
                const _OnboardingPageThree(),
              ],
            ),
          ),

          // Bottom Control Bar: Smooth Page Indicator Dots + CTA Button
          Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              children: [
                // Page Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.secondary
                            : AppColors.borderFocused,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapH24,

                // Primary CTA Button
                _currentPage == 2
                    ? AppPrimaryButton(
                        label: 'Get Started',
                        icon: Icons.rocket_launch_rounded,
                        onPressed: _onSkipPressed,
                      )
                    : AppPrimaryButton(
                        label: 'Continue',
                        trailingIcon: Icons.arrow_forward_rounded,
                        onPressed: _onNextPressed,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Page 1: Welcome to WakeWise
class _OnboardingPageOne extends StatelessWidget {
  const _OnboardingPageOne();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          // Sunrise Alarm Illustration Card
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.cardAccentGradient,
              boxShadow: AppShadows.medium,
              border: Border.all(color: AppColors.primaryLight, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                  ),
                ),
                const Icon(
                  Icons.wb_sunny_rounded,
                  size: 90,
                  color: AppColors.primary,
                ),
                Positioned(
                  bottom: 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: AppSpacing.borderRadiusFull,
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.alarm, color: Colors.white, size: 16),
                        AppSpacing.gapW4,
                        Text(
                          '07:00 AM',
                          style: AppTypography.labelSmall.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapH32,

          Text(
            'Welcome to WakeWise',
            style: AppTypography.displayMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH12,
          Text(
            'Wake smarter, not harder.',
            style: AppTypography.headlineSmall.copyWith(color: AppColors.secondaryDark),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH12,
          Text(
            'Transform your morning routine with gentle sunrise lighting, AI news briefs, and engaging wake-up missions.',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  ),
);
  }
}

/// Page 2: Challenge-Based Alarms
class _OnboardingPageTwo extends StatelessWidget {
  const _OnboardingPageTwo();

  @override
  Widget build(BuildContext context) {
    final challenges = [
      {'icon': Icons.calculate_rounded, 'name': 'Math', 'desc': 'Solve equations to snooze'},
      {'icon': Icons.camera_alt_rounded, 'name': 'Camera', 'desc': 'Snap a photo of your sink'},
      {'icon': Icons.qr_code_scanner_rounded, 'name': 'QR Code', 'desc': 'Scan barcode in kitchen'},
      {'icon': Icons.directions_walk_rounded, 'name': 'Walk', 'desc': 'Take 30 physical steps'},
      {'icon': Icons.vibration_rounded, 'name': 'Shake', 'desc': 'Vigorously shake your phone'},
    ];

    return Padding(
      padding: AppSpacing.pagePadding,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Challenge-Based Alarms',
              style: AppTypography.displaySmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapH8,
            Text(
              'Guaranteed to wake your brain up before turning off.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapH24,

            // Challenges List
            Column(
              children: challenges.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.4),
                            borderRadius: AppSpacing.borderRadiusMd,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: AppColors.secondaryDark,
                            size: 24,
                          ),
                        ),
                        AppSpacing.gapW16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] as String,
                                style: AppTypography.titleLarge,
                              ),
                              Text(
                                item['desc'] as String,
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page 3: Streaks, XP & Analytics
class _OnboardingPageThree extends StatelessWidget {
  const _OnboardingPageThree();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppCard.accent(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: AppColors.secondary, size: 40),
                        AppSpacing.gapW8,
                        Text(
                          '7 Day Streak!',
                          style: AppTypography.displayMedium.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    AppSpacing.gapH16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _FeatureBadge(
                          icon: Icons.bolt_rounded,
                          title: '350 XP',
                          subtitle: 'Earned this week',
                        ),
                        _FeatureBadge(
                          icon: Icons.insights_rounded,
                          title: '94% On Time',
                          subtitle: 'Wake up score',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.gapH32,

              Text(
                'Streaks, XP & Analytics',
                style: AppTypography.displaySmall,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapH12,
              Text(
                'Build consistent morning habits, earn XP rewards, and track your sleep consistency over time.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: AppSpacing.paddingAllSm,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: AppShadows.soft,
          ),
          child: Icon(icon, color: AppColors.secondary, size: 28),
        ),
        AppSpacing.gapH8,
        Text(title, style: AppTypography.titleLarge),
        Text(subtitle, style: AppTypography.bodySmall),
      ],
    );
  }
}
