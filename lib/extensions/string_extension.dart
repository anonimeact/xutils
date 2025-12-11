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
  /// Example usage:
  /// ```dart
  ///  Example 1: ISO8601 UTC string, default local conversion
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
  /// The method will:
  /// 1. Attempt parsing as ISO8601 (UTC) if [originFormat] is null.
  /// 2. If ISO8601 fails, it tries a set of common formats defined in [commonFormats].
  /// 3. Use the [_supportedLocales] for parsing non-UTC formats to handle locale-specific differences.
  ///
  /// Returns null if parsing fails.
  DateTime? toDateTime({String? originFormat, bool asLocal = true}) {
    if (this == null || this!.isEmpty) return null;

    DateTime? parsed;

    // List of common date/time formats for fallback
    final List<String> commonFormats = [
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", // ISO8601 with milliseconds
      "yyyy-MM-dd'T'HH:mm:ss'Z'", // ISO8601 without milliseconds
      "yyyy-MM-dd HH:mm:ss.SSS", // Database format with milliseconds
      "yyyy-MM-dd HH:mm:ss", // Database format without milliseconds
      "yyyy/MM/dd HH:mm:ss.SSS",
      "yyyy/MM/dd HH:mm:ss",
      "dd/MM/yyyy HH:mm:ss",
      "MM/dd/yyyy HH:mm:ss",
      "dd-MM-yyyy HH:mm:ss",
      "MM-dd-yyyy HH:mm:ss",
      "dd/MM/yyyy",
      "MM/dd/yyyy",
      "yyyy-MM-dd",
      "yyyy/MM/dd",
      "MM-dd-yyyy",
      "dd-MM-yyyy",
    ];

    // Attempt parsing using originFormat first, if provided
    if (originFormat != null) {
      for (final locale in _supportedLocales) {
        try {
          parsed = DateFormat(originFormat, locale).parseStrict(this!);
          break;
        } catch (e) {
          debugPrint(
            'toDateTime parse with format "$originFormat" failed for locale $locale: $e',
          );
        }
      }
    } else {
      // Attempt ISO8601 parsing first
      try {
        parsed = DateTime.parse(this!);
      } catch (_) {
        // Fallback to common formats
        for (final format in commonFormats) {
          for (final locale in _supportedLocales) {
            try {
              parsed = DateFormat(format, locale).parseStrict(this!);
              break;
            } catch (_) {}
          }
          if (parsed != null) break;
        }
      }
    }

    if (parsed == null) return null;

    // Convert to local time if requested
    return asLocal ? parsed.toLocal() : parsed;
  }

  /// Converts a date string into a desired target format.
  ///
  /// - [originFormat]: Optional. If provided, parses the string using this format.
  ///   If null, attempts to parse using common formats via `toDateTime`.
  /// - [targetFormat]: The desired output format. Defaults to 'dd/MM/yyyy'.
  ///
  /// Returns an empty string if parsing or formatting fails.
  String formatDateString({
    String? originFormat,
    String targetFormat = 'dd/MM/yyyy',
  }) {
    if (this == null || this!.isEmpty) return '';

    // Parse the string into DateTime
    final dt = toDateTime(originFormat: originFormat);
    if (dt == null) return '';

    // Format DateTime into target format using supported locales
    for (final locale in _supportedLocales) {
      try {
        return DateFormat(targetFormat, locale).format(dt);
      } catch (e) {
        debugPrint('formatDateString failed for locale $locale: $e');
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
