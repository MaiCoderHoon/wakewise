import 'package:equatable/equatable.dart';

/// Achievement / Badge entity for WakeWise Gamification System
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final int requiredValue;
  final int currentValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.requiredValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  double get progress => (currentValue / requiredValue).clamp(0.0, 1.0);

  Achievement copyWith({
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      iconName: iconName,
      requiredValue: requiredValue,
      currentValue: currentValue ?? this.currentValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconName,
        requiredValue,
        currentValue,
        isUnlocked,
        unlockedAt,
      ];
}
