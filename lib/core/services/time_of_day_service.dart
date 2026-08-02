/// Enum representing the 4 circadian theme phases throughout the day
enum WakeTheme {
  /// Morning phase: 5:00 AM – 11:00 AM
  morning,

  /// Afternoon phase: 11:00 AM – 5:00 PM
  afternoon,

  /// Evening phase: 5:00 PM – 8:00 PM
  evening,

  /// Night phase: 8:00 PM – 5:00 AM
  night,
}

/// Service responsible for calculating the active [WakeTheme] and time-of-day boundaries
/// based on the device's local time.
class TimeOfDayService {
  const TimeOfDayService();

  /// Determines the active [WakeTheme] for a given [DateTime] (defaults to current local time).
  ///
  /// Time ranges:
  /// - 🌅 Morning: 5:00 AM – 11:00 AM (hours 5..10)
  /// - ☀️ Afternoon: 11:00 AM – 5:00 PM (hours 11..16)
  /// - 🌇 Evening: 5:00 PM – 8:00 PM (hours 17..19)
  /// - 🌙 Night: 8:00 PM – 5:00 AM (hours 20..23, 0..4)
  WakeTheme getThemeForTime([DateTime? now]) {
    final current = now ?? DateTime.now();
    final hour = current.hour;

    if (hour >= 5 && hour < 11) {
      return WakeTheme.morning;
    } else if (hour >= 11 && hour < 17) {
      return WakeTheme.afternoon;
    } else if (hour >= 17 && hour < 20) {
      return WakeTheme.evening;
    } else {
      return WakeTheme.night;
    }
  }

  /// Calculates the exact [DateTime] for the next theme transition boundary.
  ///
  /// Boundary hours: 5:00, 11:00, 17:00, and 20:00.
  DateTime getNextBoundary([DateTime? now]) {
    final current = now ?? DateTime.now();
    final hour = current.hour;

    if (hour < 5) {
      return DateTime(current.year, current.month, current.day, 5);
    } else if (hour < 11) {
      return DateTime(current.year, current.month, current.day, 11);
    } else if (hour < 17) {
      return DateTime(current.year, current.month, current.day, 17);
    } else if (hour < 20) {
      return DateTime(current.year, current.month, current.day, 20);
    } else {
      // Next boundary is 5:00 AM tomorrow
      final tomorrow = current.add(const Duration(days: 1));
      return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5);
    }
  }

  /// Calculates the [Duration] remaining until the next theme boundary.
  Duration getTimeUntilNextBoundary([DateTime? now]) {
    final current = now ?? DateTime.now();
    final nextBoundary = getNextBoundary(current);
    final diff = nextBoundary.difference(current);

    // Add a 1-second safety buffer to ensure boundary hour is crossed
    return diff.isNegative ? const Duration(seconds: 1) : diff + const Duration(seconds: 1);
  }
}
