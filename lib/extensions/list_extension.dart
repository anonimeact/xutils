/// A collection of useful List extensions to simplify common operations.
extension ListUtils<T> on List<T> {
  /// Returns a **new list** sorted by the value produced by [selector].
  ///
  /// Does NOT modify the original list.
  ///
  /// Example:
  /// ```dart
  /// final nums = [3, 1, 5, 2];
  /// final sorted = nums.sortedBy((n) => n);
  /// -> sorted = [1, 2, 3, 5]
  /// -> nums remains = [3, 1, 5, 2]
  /// ```
  /// - If [selector] is provided → uses selector
  /// - If [selector] is null and T is Comparable → sorts by itself
  List<T> sortIt<R extends Comparable>([R Function(T)? selector]) {
    final copy = [...this];

    if (selector == null) {
      if (isEmpty || this.first is! Comparable) {
        throw StateError(
          "sortIt() without selector requires T to be Comparable.",
        );
      }
      copy.sort(); // direct sort for primitives
      return copy;
    }

    copy.sort((a, b) => selector(a).compareTo(selector(b)));
    return copy;
  }

  /// Returns a **new list** sorted in descending order based on [selector].
  ///
  /// Does NOT modify the original list.
  List<T> sortItDesc<R extends Comparable>([R Function(T)? selector]) {
    final copy = [...this];

    if (selector == null) {
      if (isEmpty || first is! Comparable) {
        throw StateError(
          "sortItDesc() without selector requires T to be Comparable.",
        );
      }
      (copy as List<Comparable>).sort((a, b) => b.compareTo(a));
      return copy;
    }

    copy.sort((a, b) => selector(b).compareTo(selector(a)));
    return copy;
  }

  /// Sorts this list in-place using the value returned by [selector].
  ///
  /// Example:
  /// ```dart
  /// final nums = [3, 1, 5, 2];
  /// nums.sortByInPlace((n) => n);
  /// -> nums = [1, 2, 3, 5]
  /// ```
  void sortItSelf<R extends Comparable>([R Function(T)? selector]) {
    if (selector == null) {
      if (isEmpty || this.first is! Comparable) {
        throw StateError(
          "sortItSelf() without selector requires T to be Comparable.",
        );
      }
      (this as List<Comparable>).sort();
      return;
    }

    sort((a, b) => selector(a).compareTo(selector(b)));
  }

  /// Sorts this list in-place in descending order.
  void sortItSelfDesc<R extends Comparable>([R Function(T)? selector]) {
    if (selector == null) {
      if (isEmpty || first is! Comparable) {
        throw StateError(
          "sortItSelfDesc() without selector requires T to be Comparable.",
        );
      }
      (this as List<Comparable>).sort((a, b) => b.compareTo(a));
      return;
    }

    sort((a, b) => selector(b).compareTo(selector(a)));
  }

  /// Groups list items by a key returned from [keySelector].
  ///
  /// Full Example:
  /// ```dart
  /// final people = [
  ///   {"name": "Alice", "city": "Tokyo"},
  ///   {"name": "Bob", "city": "Osaka"},
  ///   {"name": "Charlie", "city": "Tokyo"},
  /// ];
  ///
  /// final grouped = people.groupBy((p) => p["city"]);
  ///
  ///  grouped result:
  /// {
  ///   "Tokyo": [
  ///     {"name": "Alice", "city": "Tokyo"},
  ///     {"name": "Charlie", "city": "Tokyo"}
  ///   ],
  ///   "Osaka": [
  ///     {"name": "Bob", "city": "Osaka"}
  ///   ]
  /// }
  /// ```
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final item in this) {
      final key = keySelector(item);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  /// Safely returns the element at [index], or `null` if out of range.
  T? elementAtOrNull({required int index}) =>
      (index >= 0 && index < length) ? this[index] : null;

  /// Splits the list into chunks of size [size].
  ///
  /// Example:
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  /// final chunks = list.chunked(2);
  /// -> [[1,2], [3,4], [5]]
  /// ```
  List<List<T>> chunked({required int size}) {
    if (size <= 0) throw ArgumentError("size must be > 0");
    final result = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      result.add(sublist(i, i + size > length ? length : i + size));
    }
    return result;
  }

  /// Maps each element using [transform] and removes `null` results.
  ///
  /// Example:
  /// ```dart
  /// final input = ["1", "x", "2"];
  /// final output = input.mapNotNull((s) => int.tryParse(s));
  /// -> output = [1, 2]
  /// ```
  List<R> mapNotNull<R>(R? Function(T) transform) {
    final output = <R>[];
    for (final item in this) {
      final value = transform(item);
      if (value != null) output.add(value);
    }
    return output;
  }
}
