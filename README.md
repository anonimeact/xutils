<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->


XUtils is a Dart/Flutter package that provides a collection of extensions for common data types such as DateTime, double, int, and String. This package simplifies data manipulation and adds extra utility methods, making your code cleaner and easier to read.

## Features

- Extensions for DateTime, double, int, and String
- Adds utility methods for common operations
- Makes code more concise and readable

## Usage

### Currency Formatting Example
```dart
double price = 15000.5;
print(price.toCurrency()); 

String priceStr = '20000';
print(priceStr.toCurrency());
''
```

### Piece op test

For other example you can see at [Dokumentasi](test/all_test.dart)

```dart
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
```

## Additional information

For more information, contributions, or issues, please visit the repository or contact the package author.
