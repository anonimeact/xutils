// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';
import 'package:xutils_pack/extensions/datetime_extension.dart';

/// Extension utilities for nullable integers.
///
/// This extension provides helper methods for formatting currency,
/// converting timestamps, checking expiration, and formatting dates.
/// Additional commonly used utilities are also included.

/// Enum representing supported currency countries,
/// including locale ID and default currency symbol.
enum CurrencyCountry {
  ID(locale: 'id_ID', symbol: 'Rp'),
  US(locale: 'en_US', symbol: '\$'),
  UK(locale: 'en_GB', symbol: '£'),
  EU(locale: 'de_DE', symbol: '€'),
  JP(locale: 'ja_JP', symbol: '¥'),
  KR(locale: 'ko_KR', symbol: '₩'),
  CN(locale: 'zh_CN', symbol: '¥'),
  IN(locale: 'hi_IN', symbol: '₹'),
  SA(locale: 'ar_SA', symbol: 'ر.س');

  final String locale;
  final String symbol;

  const CurrencyCountry({required this.locale, required this.symbol});
}

extension IntExtension on int? {
  /// Converts the integer (assumed as monetary value) into Indonesian Rupiah format.
  ///
  /// Example:
  /// ```dart
  /// 15000.toRupiah(); // "Rp15.000"
  /// 15000.toRupiah(usingSymbol: false); // "15.000"
  /// ```
  ///
  /// If the integer is `null`, this will return `"Rp0"` or `"0"` depending on [usingSymbol].
  String toRupiah({bool usingSymbol = true}) {
    final formatter = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      decimalDigits: 0,
    );
    final formattedRupiah = formatter.format(this ?? 0);
    return usingSymbol ? formattedRupiah : formattedRupiah.replaceAll('Rp', '');
  }

  /// Converts the integer into a formatted currency string using [CurrencyCountry].
  ///
  /// Example:
  /// ```dart
  /// 15000.toCurrency(country: CurrencyCountry.US); // $15,000
  /// 15000.toCurrency(country: CurrencyCountry.JP); // ¥15,000
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

    return formatter.format(this ?? 0).trim();
  }

  /// Converts the integer (assumed as millisecondsSinceEpoch) to a [DateTime].
  ///
  /// Returns `null` if the integer itself is `null`.
  DateTime? toDate() {
    if (this == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(this!);
  }

  /// Returns `true` if the timestamp (millisecondsSinceEpoch) has already passed.
  ///
  /// If the integer is `null`, this returns `true` by default.
  bool isExpired() {
    if (this == null) return true;
    final inDateTime = DateTime.fromMillisecondsSinceEpoch(this!);
    return inDateTime.isBefore(DateTime.now());
  }

  /// Returns `true` if the timestamp plus a given [grace] duration
  /// has already passed.
  ///
  /// Useful for applying a buffer time or tolerance.
  ///
  /// If the integer is `null`, this returns `true` by default.
  bool isExpiredWith({Duration grace = Duration.zero}) {
    if (this == null) return true;
    final inDateTime = DateTime.fromMillisecondsSinceEpoch(this!);
    return inDateTime.add(grace).isBefore(DateTime.now());
  }

  /// Formats the integer (assumed as millisecondsSinceEpoch) using a specified [toFormat].
  ///
  /// Example:
  /// ```dart
  /// 1700000000000.formatDate(toFormat: "dd MMM yyyy");
  /// ```
  ///
  /// Returns `null` if the integer is `null`.
  String? formatDate({String toFormat = 'dd MM yyyy'}) {
    if (this == null) return null;
    return this?.toDate()?.formatDate(targetFormat: toFormat);
  }

  // ---------------------------------------------------------------------------
  // Additional commonly-used utilities
  // ---------------------------------------------------------------------------

  /// Returns the integer value or 0 if null.
  ///
  /// Useful for avoiding null checks in arithmetic operations.
  int safe() => this ?? 0;

  /// Returns true if the integer is greater than zero.
  ///
  /// Null values return false.
  bool isPositive() => (this ?? 0) > 0;

  /// Returns true if the integer is less than zero.
  ///
  /// Null values return false.
  bool isNegative() => (this ?? 0) < 0;

  /// Converts the integer to a percentage.
  /// based on total
  /// Example:
  /// ```dart
  /// 10.toPercentage(total: 100); // "10%"
  /// ```
  ///
  /// If the value is null, this returns `null`.
  String? toPercentage({required int total, int fixInto = 2}) {
    if (this == null) return null;
    return '${(this!.toDouble() / total * 100).toStringAsFixed(fixInto)}%';
  }
}
