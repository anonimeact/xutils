import 'package:intl/intl.dart';

/// Extension utilities for nullable DateTime.
///
/// Includes helpers for expiration checks, flexible date formatting,
/// comparison helpers (today, yesterday, same-day), age calculation,
/// and timestamp conversions.
extension DatetimeExtension on DateTime? {
  /// Locales used for formatting.
  static const _supportedLocales = [
    "id_ID",
    "en_US",
    "en_GB",
    "fr_FR",
    "de_DE",
    "es_ES",
    "it_IT",
    "pt_BR",
  ];

  /// Returns `true` if the date is null or occurs before the current moment.
  ///
  /// Example:
  /// ```dart
  /// myDate.isExpired();
  /// ```
  bool isExpired() {
    if (this == null) return true;
    return this!.isBefore(DateTime.now());
  }

  /// Returns `true` if the date plus a grace duration
  /// occurs before the current moment.
  ///
  /// Useful when adding tolerance for expiration logic.
  bool isExpiredWith({Duration grace = Duration.zero}) {
    if (this == null) return true;
    return this!.add(grace).isBefore(DateTime.now());
  }

  /// Formats the date into a string using the given [targetFormat].
  ///
  /// Attempts to format using multiple fallback locales.
  ///
  /// Example:
  /// ```dart
  /// myDate.formatDate(targetFormat: "dd MMM yyyy");
  /// ```
  ///
  /// Returns empty string if null or formatting fails.
  String formatDate({String? targetFormat = 'dd MM yyyy'}) {
    if (this == null) return '';
    for (final locale in _supportedLocales) {
      try {
        return DateFormat(targetFormat, locale).format(this!);
      } catch (_) {}
    }
    return "";
  }

  /// Returns true if the date occurs on the same calendar day as [other].
  bool isSameDay(DateTime other) {
    if (this == null) return false;
    return this!.year == other.year &&
        this!.month == other.month &&
        this!.day == other.day;
  }

  /// Returns true if the date is today.
  bool isToday() => isSameDay(DateTime.now());

  /// Returns true if the date is yesterday.
  bool isYesterday() =>
      isSameDay(DateTime.now().subtract(const Duration(days: 1)));

  /// Returns true if the date is tomorrow.
  bool isTomorrow() => isSameDay(DateTime.now().add(const Duration(days: 1)));

  /// Returns the start of the day (00:00:00).
  DateTime? get beginningOfDay {
    if (this == null) return null;
    return DateTime(this!.year, this!.month, this!.day);
  }

  /// Returns the end of the day (23:59:59.999).
  DateTime? get endOfDay {
    if (this == null) return null;
    return DateTime(this!.year, this!.month, this!.day, 23, 59, 59, 999);
  }

  /// Returns a relative time string such as:
  /// "2 minutes ago", "3 hours ago", "Tomorrow", etc.
  ///
  /// Example:
  /// ```dart
  /// myDate.formatRelative();
  /// ```
  String formatRelative() {
    if (this == null) return "";

    final now = DateTime.now();
    final dt = this!;

    final diff = now.difference(dt);
    final seconds = diff.inSeconds.abs();
    final minutes = diff.inMinutes.abs();
    final hours = diff.inHours.abs();
    final days = diff.inDays.abs();

    if (isToday()) {
      if (seconds < 60) return "Just now";
      if (minutes < 60) return "$minutes minute(s) ago";
      return "$hours hour(s) ago";
    }

    if (isYesterday()) return "Yesterday";
    if (isTomorrow()) return "Tomorrow";

    if (days < 30) return "$days day(s) ago";
    if (days < 365) return "${(days / 30).floor()} month(s) ago";

    return "${(days / 365).floor()} year(s) ago";
  }

  /// Calculates age (useful for birthdates).
  int? get age {
    if (this == null) return null;

    final today = DateTime.now();
    int age = today.year - this!.year;

    if (today.month < this!.month ||
        (today.month == this!.month && today.day < this!.day)) {
      age--;
    }

    return age;
  }

  /// Converts the date to epoch milliseconds.
  int? toEpoch() => this?.millisecondsSinceEpoch;

  /// Converts the date to epoch seconds.
  int? toEpochSeconds() =>
      this == null ? null : (this!.millisecondsSinceEpoch ~/ 1000);

  /// Adders / Subtractors
  DateTime? addDays(int days) => this?.add(Duration(days: days));

  DateTime? addHours(int hours) => this?.add(Duration(hours: hours));

  DateTime? addMinutes(int minutes) => this?.add(Duration(minutes: minutes));

  DateTime? subtractDays(int days) => this?.subtract(Duration(days: days));

  DateTime? subtractHours(int hours) => this?.subtract(Duration(hours: hours));

  /// Returns the current age in full years.
  ///
  /// Example:
  ///
  /// DateTime(1990, 5, 12).ageYears; // 33
  ///
  int get ageYears {
    if (this == null) return 0;

    final now = DateTime.now();
    int years = now.year - this!.year;

    // if birthday hasn't happened yet this year, subtract one
    if (now.month < this!.month ||
        (now.month == this!.month && now.day < this!.day)) {
      years--;
    }

    return years;
  }

  /// Returns the difference between this date and [other]
  /// as a Duration.
  /// If either is null, returns Duration.zero.
  Duration differenceFrom(DateTime? other) {
    if (this == null || other == null) return Duration.zero;
    return this!.difference(other);
  }

  /// Absolute difference (ignores positive/negative).
  Duration differenceAbs(DateTime? other) {
    final diff = differenceFrom(other);
    return diff.isNegative ? diff * -1 : diff;
  }

  /// Difference in minutes.
  int diffInMinutes(DateTime? other, {bool abs = false}) {
    final d = abs ? differenceAbs(other) : differenceFrom(other);
    return d.inMinutes;
  }

  /// Difference in hours.
  int diffInHours(DateTime? other, {bool abs = false}) {
    final d = abs ? differenceAbs(other) : differenceFrom(other);
    return d.inHours;
  }
}
