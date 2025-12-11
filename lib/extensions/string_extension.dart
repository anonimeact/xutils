import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:xutils_pack/extensions/datetime_extension.dart';
import 'int_extension.dart';

/// Extension utilities for nullable Strings.
///
/// Includes helpers for numeric parsing, date formatting,
/// currency formatting, validation, masking, capitalization,
/// and other commonly used transformations.
extension StringExtension on String? {
  /// Locales used for parsing date formats.
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

  /// Returns only the numeric characters from the string.
  ///
  /// Example:
  /// ```dart
  /// "a1b2c3".numericOnly(); // "123"
  /// ```
  ///
  /// Returns null if string is null.
  String? numericOnly() {
    if (this == null) return null;
    return this!.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Converts a numeric string to a double.
  /// Returns null if parsing fails or string is empty.
  double? toDouble() {
    if (this == null) return null;
    final regex = RegExp(r'^-?\d*\.?\d*');
    final match = regex.firstMatch(this!);
    final numericString = match?.group(0);

    if (numericString == null || numericString.isEmpty) return null;
    return double.tryParse(numericString);
  }

  /// Converts a numeric string to an integer.
  /// Returns null if parsing fails or string is empty.
  int? toInt() {
    if (this == null) return null;
    return toDouble()?.toInt();
  }

  /// Checks whether the string contains only numbers.
  bool get isNumeric {
    if (this == null || this!.isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(this!);
  }

  /// Interprets the string as an epoch timestamp (milliseconds)
  /// and formats it according to [targetFormat].
  String? formatTimestampEpoch({String targetFormat = 'dd MM yyyy'}) {
    if (this == null || this!.isEmpty) return null;
    final epoch = toInt();
    if (epoch == null) return null;

    final dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
    return dateTime.formatDate(targetFormat: targetFormat);
  }

  /// Parameters:
  /// - [originFormat]: Optional. The format string for DateFormat. If null, ISO8601 UTC is assumed.
  /// - [asLocal]: Optional. Default true. If true, the resulting DateTime is converted to local time.
  ///
  /// Returns:
  /// - DateTime? the parsed DateTime, or null if parsing fails.
  /// Example usage:
  /// ```dart
  /// // Example 1: ISO8601 UTC string, default local conversion
  /// String utcString = "2025-12-13T01:44:43.147498Z";
  /// DateTime? dtLocal = utcString.toDateTime();
  /// print(dtLocal);
  /// -> Output (if timezone UTC+7): 2025-12-13 08:44:43.147498
  ///
  /// Example 2: ISO8601 UTC string, keep as UTC
  /// DateTime? dtUtc = utcString.toDateTime(asLocal: false);
  /// print(dtUtc);
  /// -> Output: 2025-12-13 01:44:43.147498Z
  ///
  /// Example 3: Custom format string
  /// String dateString = "13/12/2025 01:44";
  /// DateTime? dtCustom = dateString.toDateTime(originFormat: "dd/MM/yyyy HH:mm");
  /// print(dtCustom);
  /// -> Output: 2025-12-13 01:44:00.000
  /// ```
  DateTime? toDateTime({String? originFormat, bool asLocal = true}) {
    if (this == null || this!.isEmpty) return null;

    DateTime? parsed;

    // Parse as ISO8601 UTC if no format is provided
    if (originFormat == null) {
      try {
        parsed = DateTime.parse(this!).toUtc();
      } catch (e) {
        debugPrint('toDateTime parse ISO8601 failed: $e');
        return null;
      }
    } else {
      for (final locale in _supportedLocales) {
        try {
          parsed = DateFormat(originFormat, locale).parseStrict(this!);
          break;
        } catch (e) {
          debugPrint('toDateTime parse with format "$originFormat" failed for locale $locale: $e');
        }
      }
    }

    if (parsed == null) return null;

    // Convert to local time if asLocal = true
    return asLocal ? parsed.toLocal() : parsed;
  }

  /// Formats a parsed date string into the given [originFormat].
  ///
  /// Returns empty string if parsing fails.
  String formatDateString({
    String originFormat = 'dd/MM/yyyy',
    String targetFormat = 'dd/MM/yyyy',
  }) {
    if (this == null || this!.isEmpty) return '';
    final dt = toDateTime(originFormat: originFormat);
    if (dt == null) return "";

    for (final locale in _supportedLocales) {
      try {
        return DateFormat(targetFormat, locale).format(dt);
      } catch (e) {
        debugPrint('formatDateString $locale');
      }
    }
    return '';
  }

  /// Converts the numeric string to Indonesian Rupiah formatted string.
  ///
  /// Example:
  /// ```dart
  /// "15000".toRupiah(); // "Rp15.000"
  /// ```
  String toRupiah({bool usingSymbol = true}) {
    final value = toInt();
    if (value == null) return "";

    final formatter = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      decimalDigits: 0,
    );
    final formatted = formatter.format(value);
    return usingSymbol ? formatted : formatted.replaceAll('Rp', '');
  }

  /// Converts the numeric string into formatted currency using [CurrencyCountry].
  ///
  /// Example:
  /// ```dart
  /// "15000".toCurrency(country: CurrencyCountry.US); // "$15,000"
  /// ```
  String toCurrency({
    CurrencyCountry country = CurrencyCountry.ID,
    bool usingSymbol = true,
    int decimalDigits = 0,
  }) {
    final value = toDouble() ?? 0.0;

    final formatter = NumberFormat.currency(
      locale: country.locale,
      symbol: usingSymbol ? country.symbol : '',
      decimalDigits: decimalDigits,
    );

    return formatter.format(value).trim();
  }

  /// Inserts a space every [every] characters.
  ///
  /// Example:
  /// ```dart
  /// "123456789".spaceEvery(3); // "123 456 789"
  /// ```
  String spaceEvery({int every = 4, String spacer = ' '}) {
    if (this == null) return '';
    return this!.replaceAllMapped(
      RegExp('(.{$every})(?=.)'),
      (m) => '${m[0]}$spacer',
    );
  }

  /// Capitalizes the first letter of the string.
  String get capitalize {
    if (this == null || this!.isEmpty) return '';
    return this![0].toUpperCase() + this!.substring(1);
  }

  /// Capitalizes every word in the string.
  String get capitalizeWords {
    if (this == null || this!.isEmpty) return '';
    return this!
        .split(' ')
        .map((w) => w.isNotEmpty ? w.capitalize : w)
        .join(' ');
  }

  /// Removes all whitespace characters.
  String get removeWhitespace {
    if (this == null) return '';
    return this!.replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncates the string safely.
  ///
  /// Example:
  /// ```dart
  /// "Hello World".truncate(5); // "Hello..."
  /// ```
  String truncate(int maxLength, {String suffix = '...'}) {
    if (this == null) return '';
    if (this!.length <= maxLength) return this!;
    return this!.substring(0, maxLength) + suffix;
  }

  /// Masks part of the string for privacy.
  ///
  /// Example:
  /// ```dart
  /// "1234567890".mask(start: 3, end: 7); // "123****890"
  /// ```
  String mask({int? start, int? end, String maskChar = '*'}) {
    if (this == null || this!.isEmpty) return '';
    final s = this!;

    if (start == null && end == null) return s;
    start ??= 0;
    end ??= this!.length;

    if (start >= s.length || end <= start) return s;

    final masked = s.replaceRange(
      start,
      end > s.length ? s.length : end,
      maskChar * (end - start),
    );

    return masked;
  }

  /// Converts string to boolean (case-insensitive).
  ///
  /// Accepts: "true", "yes", "1".
  bool? toBool() {
    if (this == null) return null;

    final value = this!.toLowerCase().trim();
    if (['true', 'yes', '1'].contains(value)) return true;
    if (['false', 'no', '0'].contains(value)) return false;

    return null;
  }

  /// Checks if the string contains ANY of provided patterns.
  bool containsAny({required List<String> patterns}) {
    if (this == null) return false;
    return patterns.any((p) => this!.contains(p));
  }

  /// Returns the empty strung if null.
  ///
  /// Useful for avoiding null checks in arithmetic operations.
  String safe() => this ?? '';
}
