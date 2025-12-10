import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:xutils_pack/extensions/string_extension.dart'; 

void main() {

  setUpAll(() async {
    await initializeDateFormatting();
  });
  group('StringExtension Tests', () {

    test('numericOnly should extract numbers', () {
      expect("a1b2c3".numericOnly(), '123');
      expect("123abc".numericOnly(), '123');
      expect("abc".numericOnly(), '');
      expect("123".numericOnly(), '123');
      expect(null.numericOnly(), null);
    });

    test('toDouble should parse numeric strings to double', () {
      expect("12.5a".toDouble(), 12.5);
      expect("abc".toDouble(), null);
      expect("".toDouble(), null);
      expect(null.toDouble(), null);
    });

    test('toInt should parse numeric strings to int', () {
      expect("123a".toInt(), 123);
      expect("12.5a".toInt(), 12);
      expect("abc".toInt(), null);
      expect(null.toInt(), null);
    });

    test('isNumeric should check if string contains only numbers', () {
      expect("123".isNumeric, true);
      expect("123a".isNumeric, false);
      expect("".isNumeric, false);
      expect(null.isNumeric, false);
    });

    // --- Test cases for Date & Time ---
    
    // Catatan: toDateTime sangat bergantung pada locale sistem dan format input.
    // Locale id_ID menggunakan format d/M/yyyy secara default.
    test('toDateTime should parse date strings with specified format', () {
      // Input format: dd/MM/yyyy
      final dateStringID = "25/12/2024";
      final dateTimeID = dateStringID.toDateTime(originFormat: "dd/MM/yyyy");
      expect(dateTimeID?.year, 2024);
      expect(dateTimeID?.month, 12);
      expect(dateTimeID?.day, 25);
      
      // Test null case
      expect(null.toDateTime(originFormat: "dd/MM/yyyy"), null);
    });
    
    test('formatDateString should format a parsed date string', () {
      // Test with an explicit format that works for id_ID locale
      final inputDateStr = "15/06/2023";
      final formatted = inputDateStr.formatDateString(originFormat: 'dd/MM/yyyy', targetFormat: 'yyyy-MM-dd');
      
      expect(formatted, "2023-06-15"); 

      // Test null/invalid case
      final invalidDate = "not a date";
      expect(invalidDate.formatDateString(), "");
    });

    test('formatTimestampEpoch should convert epoch string to formatted date', () {
      // 1672531200000 ms is 2023-01-01 00:00:00 UTC (approx, depending on local TZ)
      final epochString = "1672531200000"; 
      expect(epochString.formatTimestampEpoch(targetFormat: 'yyyy'), '2023');
      expect(epochString.formatTimestampEpoch(targetFormat: 'dd MMM yyyy'), isNotNull);

      // Test invalid epoch string
      expect("abc".formatTimestampEpoch(), null);
      expect(null.formatTimestampEpoch(), null);
    });


    // --- Test cases for Currency ---

    test('toRupiah should format string to IDR currency', () {
      expect("15000".toRupiah(), 'Rp15.000');
      expect("1500000".toRupiah(usingSymbol: false), '1.500.000');
      expect("abc".toRupiah(), '');
    });

    // Uncomment this test when CurrencyCountry enum is defined
    /*
    test('toCurrency should format string to specified currency', () {
      expect("15000".toCurrency(country: CurrencyCountry.US), '\$15,000');
      expect("50.50".toCurrency(country: CurrencyCountry.US, decimalDigits: 2), '\$50.50');
      expect("10000".toCurrency(country: CurrencyCountry.ID, usingSymbol: false), '10.000');
    });
    */


    // --- Test cases for String manipulation ---

    test('spaceEvery should insert spaces', () {
      expect("123456789".spaceEvery(every: 3), '123 456 789');
      expect("12345".spaceEvery(every: 4), '1234 5');
      expect(null.spaceEvery(), '');
    });

    test('capitalize should capitalize the first letter', () {
      expect("hello world".capitalize, 'Hello world');
      expect("".capitalize, '');
      expect(null.capitalize, '');
    });

    test('capitalizeWords should capitalize the first letter of each word', () {
      expect("hello world".capitalizeWords, 'Hello World');
      expect("this is a test".capitalizeWords, 'This Is A Test');
      expect(null.capitalizeWords, '');
    });

    test('removeWhitespace should remove all whitespaces', () {
      expect("  hello world  ".removeWhitespace, 'helloworld');
      expect("\t tabs \n and newlines".removeWhitespace, 'tabsandnewlines');
      expect(null.removeWhitespace, '');
    });

    test('truncate should shorten string with suffix', () {
      expect("Hello World".truncate(5), 'Hello...');
      expect("Short".truncate(10), 'Short');
      expect("Hello".truncate(5, suffix: '...'), 'Hello');
      expect(null.truncate(5), '');
    });

    test('mask should mask parts of the string', () {
      expect("1234567890".mask(start: 3, end: 7), '123****890');
      expect("password".mask(start: 0, end: 8, maskChar: '#'), '########');
      expect("short".mask(start: 2), 'sh***'); // end clipped to length
      expect(null.mask(), '');
    });

    test('toBool should convert common strings to boolean', () {
      expect("true".toBool(), true);
      expect("YES".toBool(), true);
      expect("1".toBool(), true);
      expect("false".toBool(), false);
      expect("no".toBool(), false);
      expect("0".toBool(), false);
      expect("maybe".toBool(), null);
      expect(null.toBool(), null);
    });

    test('containsAny should check for list of patterns', () {
      expect("apple banana".containsAny(patterns: ['apple', 'kiwi']), true);
      expect("kiwi orange".containsAny(patterns: ['apple', 'banana']), false);
      expect(null.containsAny(patterns: ['apple']), false);
    });

    test('safe should return empty string if null', () {
      String? nullableString;
      expect(nullableString.safe(), '');
      expect("hello".safe(), 'hello');
    });
  });
}
