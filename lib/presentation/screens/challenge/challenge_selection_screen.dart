import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/theme/app_spacing.dart';
import '../../../domain/challenges/entities/challenge_difficulty.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_hero_header.dart';
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AppPageScaffold(
      isScrollable: true,
      padding: EdgeInsets.zero,
      appBar: AppBar(
        title: const Text('Challenge Engine'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Hero Container
          AppHeroHeader(
            child: Row(
              children: [
                Container(
                  padding: AppSpacing.paddingAllMd,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.extension_rounded, color: primaryColor, size: 32),
                ),
                AppSpacing.gapW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wake-Up Missions', style: theme.textTheme.headlineMedium),
                      AppSpacing.gapH4,
                      Text(
                        'Select a challenge type and difficulty level to test your wake-up routine.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.gapH24,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Difficulty Selector
                Text('Select Difficulty', style: theme.textTheme.headlineSmall),
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
                              color: isSelected ? primaryColor : theme.colorScheme.surface,
                              borderRadius: AppSpacing.borderRadiusLg,
                              border: Border.all(
                                color: isSelected ? primaryColor : theme.colorScheme.outline.withValues(alpha: 0.4),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  diff.displayName,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                AppSpacing.gapH4,
                                Text(
                                  '+${diff.xpMultiplier} XP',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                Text('Select Challenge', style: theme.textTheme.headlineSmall),
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
                        borderRadius: AppSpacing.radiusLg,
                        border: Border.all(
                          color: isSelected ? primaryColor : theme.colorScheme.outline.withValues(alpha: 0.4),
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: AppSpacing.paddingAllSm,
                              decoration: BoxDecoration(
                                color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: isSelected ? Colors.white : primaryColor,
                                size: 26,
                              ),
                            ),
                            AppSpacing.gapW16,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'] as String, style: theme.textTheme.titleLarge),
                                  AppSpacing.gapH4,
                                  Text(item['desc'] as String, style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: primaryColor,
                                size: 24,
                              ),
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
          ),
        ],
      ),
    );
  }
}
