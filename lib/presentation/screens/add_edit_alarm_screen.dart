import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/theme/app_colors.dart';
import '../../core/constants/theme/app_shadows.dart';
import '../../core/constants/theme/app_spacing.dart';
import '../../core/constants/theme/app_typography.dart';
import '../../domain/entities/alarm.dart';
import '../blocs/alarm/alarm_bloc.dart';
import '../blocs/alarm/alarm_event.dart';
import '../widgets/app_card.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/app_primary_button.dart';

/// Screen for adding a new alarm or editing an existing alarm
class AddEditAlarmScreen extends StatefulWidget {
  final Alarm? initialAlarm;

  const AddEditAlarmScreen({
    super.key,
    this.initialAlarm,
  });

  @override
  State<AddEditAlarmScreen> createState() => _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends State<AddEditAlarmScreen> {
  late TimeOfDay _selectedTime;
  late TextEditingController _labelController;
  late Set<int> _selectedDays; // 1 = Mon, 7 = Sun
  late ChallengeType _selectedChallenge;

  bool get _isEditing => widget.initialAlarm != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialAlarm;
    _selectedTime = initial?.timeOfDay ?? const TimeOfDay(hour: 7, minute: 0);
    _labelController = TextEditingController(text: initial?.label ?? 'Morning Alarm');
    _selectedDays = Set<int>.from(initial?.repeatDays ?? [1, 2, 3, 4, 5]);
    _selectedChallenge = initial?.challengeType ?? ChallengeType.math;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.surface,
              hourMinuteColor: AppColors.surfaceSubtle,
              hourMinuteTextColor: AppColors.textPrimary,
              dayPeriodColor: AppColors.primaryLight,
              dayPeriodTextColor: AppColors.textPrimary,
              dialHandColor: AppColors.secondary,
              dialBackgroundColor: AppColors.surfaceSubtle,
              shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _onSave() {
    final alarm = Alarm(
      id: widget.initialAlarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      label: _labelController.text.trim().isEmpty ? 'Alarm' : _labelController.text.trim(),
      repeatDays: _selectedDays.toList()..sort(),
      challengeType: _selectedChallenge,
      enabled: widget.initialAlarm?.enabled ?? true,
      createdAt: widget.initialAlarm?.createdAt ?? DateTime.now(),
    );

    if (_isEditing) {
      context.read<AlarmBloc>().add(UpdateAlarm(alarm));
    } else {
      context.read<AlarmBloc>().add(AddAlarm(alarm));
    }

    context.pop();
  }

  void _onDelete() {
    if (_isEditing) {
      context.read<AlarmBloc>().add(DeleteAlarm(widget.initialAlarm!.id));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedHour = _selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod;
    final formattedMinute = _selectedTime.minute.toString().padLeft(2, '0');
    final period = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

    return AppPageScaffold(
      isScrollable: true,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Alarm' : 'New Alarm'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              onPressed: _onDelete,
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Picker Display Card
          AppCard.accent(
            onTap: _pickTime,
            child: Column(
              children: [
                Text(
                  'ALARM TIME',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.secondaryDark,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                AppSpacing.gapH8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${formattedHour.toString().padLeft(2, '0')}:$formattedMinute',
                      style: AppTypography.displayLarge.copyWith(
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.gapW8,
                    Text(
                      period,
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.secondaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_calendar_rounded, size: 16, color: AppColors.textSecondary),
                    AppSpacing.gapW4,
                    Text(
                      'Tap to change time',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          AppSpacing.gapH24,

          // Label Input Field
          Text('Label', style: AppTypography.headlineSmall),
          AppSpacing.gapH8,
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              hintText: 'e.g. Work Wake Up, Workout',
              prefixIcon: Icon(Icons.label_outline_rounded, color: AppColors.textSecondary),
            ),
          ),

          AppSpacing.gapH24,

          // Repeat Days Selector
          Text('Repeat Days', style: AppTypography.headlineSmall),
          AppSpacing.gapH8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DayChip(dayIndex: 1, label: 'Mon', isSelected: _selectedDays.contains(1), onToggle: _toggleDay),
              _DayChip(dayIndex: 2, label: 'Tue', isSelected: _selectedDays.contains(2), onToggle: _toggleDay),
              _DayChip(dayIndex: 3, label: 'Wed', isSelected: _selectedDays.contains(3), onToggle: _toggleDay),
              _DayChip(dayIndex: 4, label: 'Thu', isSelected: _selectedDays.contains(4), onToggle: _toggleDay),
              _DayChip(dayIndex: 5, label: 'Fri', isSelected: _selectedDays.contains(5), onToggle: _toggleDay),
              _DayChip(dayIndex: 6, label: 'Sat', isSelected: _selectedDays.contains(6), onToggle: _toggleDay),
              _DayChip(dayIndex: 7, label: 'Sun', isSelected: _selectedDays.contains(7), onToggle: _toggleDay),
            ],
          ),

          AppSpacing.gapH24,

          // Challenge Selector
          Text('Wake-Up Challenge', style: AppTypography.headlineSmall),
          AppSpacing.gapH8,
          Column(
            children: ChallengeType.values.map((challenge) {
              final isSelected = _selectedChallenge == challenge;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: AppCard(
                  onTap: () => setState(() => _selectedChallenge = challenge),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
                          challenge.icon,
                          color: isSelected ? AppColors.textOnPrimary : AppColors.secondary,
                          size: 22,
                        ),
                      ),
                      AppSpacing.gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(challenge.displayName, style: AppTypography.titleLarge),
                            Text(challenge.description, style: AppTypography.bodySmall),
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

          // Save Button
          AppPrimaryButton(
            label: _isEditing ? 'Save Changes' : 'Create Alarm',
            icon: Icons.check_rounded,
            onPressed: _onSave,
          ),

          AppSpacing.gapH32,
        ],
      ),
    );
  }

  void _toggleDay(int dayIndex) {
    setState(() {
      if (_selectedDays.contains(dayIndex)) {
        _selectedDays.remove(dayIndex);
      } else {
        _selectedDays.add(dayIndex);
      }
    });
  }
}

class _DayChip extends StatelessWidget {
  final int dayIndex;
  final String label;
  final bool isSelected;
  final ValueChanged<int> onToggle;

  const _DayChip({
    required this.dayIndex,
    required this.label,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(dayIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected ? AppShadows.soft : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
