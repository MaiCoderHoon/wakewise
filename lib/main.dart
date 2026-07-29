import 'package:flutter/material.dart';
import 'core/constants/theme/app_colors.dart';
import 'core/constants/theme/app_shadows.dart';
import 'core/constants/theme/app_spacing.dart';
import 'core/constants/theme/app_typography.dart';
import 'core/constants/theme/light_theme.dart';
import 'presentation/widgets/app_card.dart';
import 'presentation/widgets/app_page_scaffold.dart';
import 'presentation/widgets/app_primary_button.dart';

void main() {
  runApp(const WakewiseApp());
}

class WakewiseApp extends StatelessWidget {
  const WakewiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WakeWise',
      theme: lightThemeData,
      home: const WakeWiseShowcaseScreen(),
    );
  }
}

class WakeWiseShowcaseScreen extends StatefulWidget {
  const WakeWiseShowcaseScreen({super.key});

  @override
  State<WakeWiseShowcaseScreen> createState() => _WakeWiseShowcaseScreenState();
}

class _WakeWiseShowcaseScreenState extends State<WakeWiseShowcaseScreen> {
  bool _isLoadingButton = false;
  int _counter = 0;

  void _triggerLoading() {
    setState(() => _isLoadingButton = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoadingButton = false;
          _counter++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      isScrollable: true,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.wb_sunny_rounded, color: AppColors.secondary, size: 28),
            AppSpacing.gapW8,
            Text(
              'WakeWise',
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Sunrise Greeting Hero
          AppCard.accent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                      child: Text(
                        'AI MORNING COMPANION',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.secondaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.auto_awesome_rounded, color: AppColors.secondary, size: 22),
                  ],
                ),
                AppSpacing.gapH16,
                Text(
                  'Good Morning, Alex',
                  style: AppTypography.displayMedium,
                ),
                AppSpacing.gapH8,
                Text(
                  'Your next AI alarm is set for 07:00 AM with gentle sunrise lighting and personalized news brief.',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),

          AppSpacing.gapH24,

          // Typography Showcase Section
          Text('Typography System', style: AppTypography.headlineMedium),
          AppSpacing.gapH12,
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plus Jakarta Sans Display', style: AppTypography.displaySmall),
                AppSpacing.gapH4,
                Text('Headline Medium (18px SemiBold)', style: AppTypography.headlineMedium),
                AppSpacing.gapH4,
                Text('Body Large (16px Regular)', style: AppTypography.bodyLarge),
                AppSpacing.gapH4,
                Text('Body Medium (14px Secondary)', style: AppTypography.bodyMedium),
                AppSpacing.gapH4,
                Text('Label Small (11px Muted)', style: AppTypography.labelSmall),
              ],
            ),
          ),

          AppSpacing.gapH24,

          // Color Palette Showcase Section
          Text('Color Tokens', style: AppTypography.headlineMedium),
          AppSpacing.gapH12,
          Row(
            children: [
              Expanded(
                child: _ColorChip(
                  color: AppColors.primary,
                  label: 'Primary\n#F8B133',
                  textColor: AppColors.textOnPrimary,
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: _ColorChip(
                  color: AppColors.secondary,
                  label: 'Secondary\n#FF8C42',
                  textColor: Colors.white,
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: _ColorChip(
                  color: AppColors.surfaceSubtle,
                  label: 'Cream Tint\n#FFF3E0',
                  textColor: AppColors.textPrimary,
                  border: Border.all(color: AppColors.border),
                ),
              ),
            ],
          ),

          AppSpacing.gapH24,

          // Primary Button Showcase Section
          Text('Reusable Buttons', style: AppTypography.headlineMedium),
          AppSpacing.gapH12,
          AppPrimaryButton(
            label: _isLoadingButton ? 'Setting Up...' : 'Set New AI Alarm (Clicks: $_counter)',
            icon: Icons.alarm_add_rounded,
            isLoading: _isLoadingButton,
            onPressed: _triggerLoading,
          ),
          AppSpacing.gapH12,
          AppPrimaryButton(
            label: 'Secondary Orange Gradient',
            icon: Icons.wb_twilight_rounded,
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.secondaryDark],
            ),
            textColor: Colors.white,
            onPressed: () {},
          ),
          AppSpacing.gapH12,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Dismiss'),
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: AppPrimaryButton(
                  label: 'Disabled',
                  isDisabled: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),

          AppSpacing.gapH32,
        ],
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final Color color;
  final String label;
  final Color textColor;
  final BoxBorder? border;

  const _ColorChip({
    required this.color,
    required this.label,
    required this.textColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllMd,
      height: 72,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppSpacing.borderRadiusLg,
        border: border,
        boxShadow: AppShadows.soft,
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}