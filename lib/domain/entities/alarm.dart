import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Available morning wake-up challenge types
enum ChallengeType {
  none,
  math,
  camera,
  qr,
  walk,
  shake,
}

extension ChallengeTypeExtension on ChallengeType {
  String get displayName {
    switch (this) {
      case ChallengeType.none:
        return 'Standard Alarm';
      case ChallengeType.math:
        return 'Math Challenge';
      case ChallengeType.camera:
        return 'Camera Photo';
      case ChallengeType.qr:
        return 'QR Code Scan';
      case ChallengeType.walk:
        return 'Step Walk';
      case ChallengeType.shake:
        return 'Phone Shake';
    }
  }

  IconData get icon {
    switch (this) {
      case ChallengeType.none:
        return Icons.alarm_rounded;
      case ChallengeType.math:
        return Icons.calculate_rounded;
      case ChallengeType.camera:
        return Icons.camera_alt_rounded;
      case ChallengeType.qr:
        return Icons.qr_code_scanner_rounded;
      case ChallengeType.walk:
        return Icons.directions_walk_rounded;
      case ChallengeType.shake:
        return Icons.vibration_rounded;
    }
  }

  String get description {
    switch (this) {
      case ChallengeType.none:
        return 'Simple sound alarm with snooze';
      case ChallengeType.math:
        return 'Solve math equations to turn off';
      case ChallengeType.camera:
        return 'Snap photo of a registered object';
      case ChallengeType.qr:
        return 'Scan barcode in another room';
      case ChallengeType.walk:
        return 'Take a specified number of steps';
      case ChallengeType.shake:
        return 'Shake your phone vigorously';
    }
  }
}

/// Core Alarm Entity
class Alarm extends Equatable {
  final String id;
  final int hour; // 0..23
  final int minute; // 0..59
  final String label;
  final List<int> repeatDays; // 1 = Mon, 7 = Sun
  final ChallengeType challengeType;
  final bool enabled;
  final DateTime createdAt;

  const Alarm({
    required this.id,
    required this.hour,
    required this.minute,
    required this.label,
    required this.repeatDays,
    required this.challengeType,
    required this.enabled,
    required this.createdAt,
  });

  /// TimeOfDay helper
  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  /// 12-hour formatted time string e.g. "07:30"
  String get formattedTime {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$m';
  }

  /// AM or PM period string
  String get formattedPeriod => hour >= 12 ? 'PM' : 'AM';

  /// Readable summary of repeat days (e.g., "Every day", "Weekdays", "Mon, Wed, Fri")
  String get formattedRepeatDays {
    if (repeatDays.isEmpty) return 'Once';
    if (repeatDays.length == 7) return 'Every day';
    if (repeatDays.length == 5 &&
        repeatDays.contains(1) &&
        repeatDays.contains(2) &&
        repeatDays.contains(3) &&
        repeatDays.contains(4) &&
        repeatDays.contains(5)) {
      return 'Weekdays';
    }
    if (repeatDays.length == 2 && repeatDays.contains(6) && repeatDays.contains(7)) {
      return 'Weekends';
    }

    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final sorted = List<int>.from(repeatDays)..sort();
    return sorted.map((d) => dayLabels[d - 1]).join(', ');
  }

  /// Copy with modifications helper
  Alarm copyWith({
    String? id,
    int? hour,
    int? minute,
    String? label,
    List<int>? repeatDays,
    ChallengeType? challengeType,
    bool? enabled,
    DateTime? createdAt,
  }) {
    return Alarm(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      label: label ?? this.label,
      repeatDays: repeatDays ?? this.repeatDays,
      challengeType: challengeType ?? this.challengeType,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        hour,
        minute,
        label,
        repeatDays,
        challengeType,
        enabled,
        createdAt,
      ];
}
