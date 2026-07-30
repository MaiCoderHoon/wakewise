import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/theme/app_colors.dart';
import '../../../core/constants/theme/app_shadows.dart';
import '../../../core/constants/theme/app_spacing.dart';
import '../../../core/constants/theme/app_typography.dart';
import '../../../domain/challenges/entities/challenge_difficulty.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/app_primary_button.dart';

/// Screen for selecting and testing wake-up challenges
class ChallengeSelectionScreen extends StatefulWidget {
  const ChallengeSelectionScreen({super.key});

  @override
  State<ChallengeSelectionScreen> createState() => _ChallengeSelectionScreenState();
}

class _ChallengeSelectionScreenState extends State<ChallengeSelectionScreen> {
  String _selectedChallengeKey = 'math';
  ChallengeDifficulty _selectedDifficulty = ChallengeDifficulty.medium;

  final challenges = [
    {
      'key': 'math',
      'title': 'Math Challenge',
      'desc': 'Solve arithmetic equations to sharpen your morning focus.',
      'icon': Icons.calculate_rounded,
    },
    {
      'key': 'memory',
      'title': 'Memory Challenge',
      'desc': 'Memorize tile patterns and repeat the sequence.',
      'icon': Icons.grid_view_rounded,
    },
    {
      'key': 'shake',
      'title': 'Shake Challenge',
      'desc': 'Shake your phone vigorously to reach your motion target.',
      'icon': Icons.vibration_rounded,
    },
    {
      'key': 'random',
      'title': 'Random Challenge',
      'desc': 'Surprise yourself with a random wake-up mission each morning.',
      'icon': Icons.casino_rounded,
    },
  ];

  void _onLaunchChallenge() {
    context.push(
      '/challenge-play',
      extra: {
        'challengeKey': _selectedChallengeKey,
        'difficulty': _selectedDifficulty,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      isScrollable: true,
      appBar: AppBar(
        title: const Text('Challenge Engine'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Hero Card
          AppCard.accent(
            child: Row(
              children: [
                Container(
                  padding: AppSpacing.paddingAllMd,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.soft,
                  ),
                  child: const Icon(Icons.extension_rounded, color: AppColors.secondary, size: 32),
                ),
                AppSpacing.gapW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wake-Up Missions', style: AppTypography.headlineMedium),
                      AppSpacing.gapH4,
                      Text(
                        'Select a challenge type and difficulty level to test your wake-up routine.',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.gapH24,

          // Difficulty Selector
          Text('Select Difficulty', style: AppTypography.headlineSmall),
          AppSpacing.gapH12,
          Row(
            children: ChallengeDifficulty.values.map((diff) {
              final isSelected = _selectedDifficulty == diff;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDifficulty = diff),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: AppSpacing.borderRadiusLg,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryDark : AppColors.border,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: isSelected ? AppShadows.soft : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            diff.displayName,
                            style: AppTypography.labelLarge.copyWith(
                              color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSpacing.gapH4,
                          Text(
                            '+${diff.xpMultiplier} XP',
                            style: AppTypography.labelSmall.copyWith(
                              color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          AppSpacing.gapH24,

          // Challenge Selection Cards
          Text('Select Challenge', style: AppTypography.headlineSmall),
          AppSpacing.gapH12,
          Column(
            children: challenges.map((item) {
              final key = item['key'] as String;
              final isSelected = _selectedChallengeKey == key;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  onTap: () => setState(() => _selectedChallengeKey = key),
                  padding: AppSpacing.paddingAllMd,
                  border: Border.all(
                    color: isSelected ? AppColors.secondary : AppColors.border,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  backgroundColor: isSelected ? AppColors.surfaceSubtle : AppColors.surface,
                  child: Row(
                    children: [
                      Container(
                        padding: AppSpacing.paddingAllSm,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceSubtle,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected ? AppColors.textOnPrimary : AppColors.secondary,
                          size: 26,
                        ),
                      ),
                      AppSpacing.gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'] as String, style: AppTypography.titleLarge),
                            AppSpacing.gapH4,
                            Text(item['desc'] as String, style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 24),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          AppSpacing.gapH32,

          // Launch Challenge Button
          AppPrimaryButton(
            label: 'Start Challenge Test',
            icon: Icons.play_arrow_rounded,
            onPressed: _onLaunchChallenge,
          ),

          AppSpacing.gapH32,
        ],
      ),
    );
  }
}
