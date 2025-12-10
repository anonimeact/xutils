import 'dart:math' as Math;

import 'package:intl/intl.dart';
import 'int_extension.dart'; // for CurrencyCountry enum

/// Extension utilities for nullable double values.
///
/// Includes helpers for rounding, safe math operations,
/// formatting numbers, converting to currency, percentage formatting,
/// and range checks.
extension DoubleExtension on double? {
  /// Returns the value or 0.0 if null.
  double safe() => this ?? 0.0;

  /// Returns true if the value is greater than zero.
  bool get isPositive => (this ?? 0) > 0;

  /// Returns true if the value is less than zero.
  bool get isNegative => (this ?? 0) < 0;

  /// Returns the absolute value.
  double get abs => this == null ? 0.0 : this!.abs();

  /// Rounds the number to [fractionDigits] decimal places.
  ///
  /// Example:
  /// ```dart
  /// 12.3456.roundTo(2); // 12.35
  /// ```
  double roundTo({required int fractionDigits}) {
    if (this == null) return 0.0;
    final factor = Math.pow(10, fractionDigits);
    return (this! * factor).round() / factor;
  }

  /// Floors the number to [fractionDigits] decimal places.
  double floorTo({required int fractionDigits}) {
    if (this == null) return 0.0;
    final factor = Math.pow(10, fractionDigits);
    return (this! * factor).floor() / factor;
  }

  /// Ceils the number to [fractionDigits] decimal places.
  double ceilTo({required int fractionDigits}) {
    if (this == null) return 0.0;
    final factor = Math.pow(10, fractionDigits);
    return (this! * factor).ceil() / factor;
  }

  /// Converts the number into a currency format using [CurrencyCountry].
  ///
  /// Example:
  /// ```dart
  /// 15000.0.toCurrency(country: CurrencyCountry.US); // "$15,000"
  /// ```
  String toCurrency({
    CurrencyCountry country = CurrencyCountry.ID,
    bool usingSymbol = true,
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.currency(
      locale: country.locale,
      symbol: usingSymbol ? country.symbol : '',
      decimalDigits: decimalDigits,
    );
    return formatter.format(safe()).trim();
  }

  /// Converts a number to Indonesian Rupiah format.
  String toRupiah({bool usingSymbol = true}) {
    final formatter = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      decimalDigits: 0,
    );
    final result = formatter.format(safe());
    return usingSymbol ? result : result.replaceAll('Rp', '');
  }

  /// Converts the number to a percentage string.
  ///
  /// Example:
  /// ```dart
  /// 0.25.toPercentage(); // "25%"
  /// ```
  String toPercentage({int decimalDigits = 0}) {
    final percent = ((this ?? 0) * 100);
    return "${percent.toStringAsFixed(decimalDigits)}%";
  }

  /// Converts the number into a formatted percentage with a space.
  ///
  /// Example:
  /// ```dart
  /// 0.25.toPercentageWithSpace(); // "25 %"
  /// ```
  String toPercentageWithSpace({int decimalDigits = 0}) {
    final percent = ((this ?? 0) * 100);
    return "${percent.toStringAsFixed(decimalDigits)} %";
  }

  /// Converts large numbers into short notation:
  ///
  /// - 1,200 → "1.2K"
  /// - 5,300,000 → "5.3M"
  /// - 7,900,000,000 → "7.9B"
  ///
  String toShortFormat() {
    final num = safe();

    if (num >= 1e12) return "${(num / 1e12).toStringAsFixed(1)}T";
    if (num >= 1e9) return "${(num / 1e9).toStringAsFixed(1)}B";
    if (num >= 1e6) return "${(num / 1e6).toStringAsFixed(1)}M";
    if (num >= 1e3) return "${(num / 1e3).toStringAsFixed(1)}K";

    return num.toString();
  }

  /// Safely divides this number by [other], returning 0 if either is null
  /// or if dividing by zero.
  double safeDivide({num? other}) {
    if (this == null || other == null || other == 0) return 0.0;
    return this! / other;
  }

  /// Returns this number multiplied safely by [other].
  double safeMultiply({num? other}) {
    if (this == null || other == null) return 0.0;
    return this! * other;
  }

  /// Clamps the number between [min] and [max].
  double clamp({required double min, required double max}) {
    final val = safe();
    if (val < min) return min;
    if (val > max) return max;
    return val;
  }

  /// Checks if the number is between [min] and [max].
  bool isBetween({required double min, required double max}) {
    final val = safe();
    return val >= min && val <= max;
  }

  /// Formats number with commas based on locale.
  ///
  /// Example:
  /// ```dart
  /// 1234567.89.formatNumber(); // "1,234,567.89"
  /// ```
  String formatNumber({String locale = 'en_US', int decimalDigits = 0}) {
    final formatter = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = decimalDigits;
    return formatter.format(safe());
  }
}
