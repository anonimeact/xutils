
import 'package:flutter_test/flutter_test.dart';
import 'package:xutils_pack/extensions/list_extension.dart';

void main() {
  group('ListUtils Extensions', () {
    
    // sortIt WITHOUT selector (Comparable only)
    test('sortIt sorts primitives ascending without selector', () {
      final nums = [3, 1, 5, 2];
      final sorted = nums.sortIt();

      expect(sorted, [1, 2, 3, 5]);
      expect(nums, [3, 1, 5, 2]); // original unchanged
    });

    test('sortItDesc sorts primitives descending without selector', () {
      final nums = [3, 1, 5, 2];
      final sorted = nums.sortItDesc();

      expect(sorted, [5, 3, 2, 1]);
      expect(nums, [3, 1, 5, 2]);
    });

    test('sortIt throws when no selector provided for non-Comparable', () {
      final list = [
        {"id": 2},
        {"id": 1}
      ];

      expect(() => list.sortIt(), throwsStateError);
    });

    // sortItSelf WITHOUT selector
    test('sortItSelf sorts primitives ascending in place', () {
      final nums = [3, 1, 5, 2];
      nums.sortItSelf();

      expect(nums, [1, 2, 3, 5]);
    });

    test('sortItSelfDesc sorts primitives descending in place', () {
      final nums = [3, 1, 5, 2];
      nums.sortItSelfDesc();

      expect(nums, [5, 3, 2, 1]);
    });

    test('sortItSelf throws when no selector provided for non-Comparable list', () {
      final items = [
        {"name": "A"},
        {"name": "B"}
      ];

      expect(() => items.sortItSelf(), throwsStateError);
    });

    // sortIt WITH selector
    test('sortIt sorts custom objects using selector', () {
      final people = [
        {"name": "Charlie", "age": 30},
        {"name": "Alice", "age": 20},
        {"name": "Bob", "age": 25},
      ];

      final sorted = people.sortIt((p) => p["age"] as int);

      expect(sorted.map((p) => p["age"]), [20, 25, 30]);
    });

    // sortItSelf WITH selector
    test('sortItSelf sorts custom objects in place using selector', () {
      final people = [
        {"name": "Charlie", "age": 30},
        {"name": "Alice", "age": 20},
        {"name": "Bob", "age": 25},
      ];

      people.sortItSelf((p) => p["age"] as int);

      expect(people.map((p) => p["age"]), [20, 25, 30]);
    });

    // sortItDesc WITH selector
    test('sortItDesc sorts custom objects descending using selector', () {
      final people = [
        {"name": "Charlie", "age": 30},
        {"name": "Alice", "age": 20},
        {"name": "Bob", "age": 25},
      ];

      final sorted = people.sortItDesc((p) => p["age"] as int);

      expect(sorted.map((p) => p["age"]), [30, 25, 20]);
    });

    // sortItSelfDesc WITH selector
    test('sortItSelfDesc sorts custom objects in place descending', () {
      final people = [
        {"name": "Charlie", "age": 30},
        {"name": "Alice", "age": 20},
        {"name": "Bob", "age": 25},
      ];

      people.sortItSelfDesc((p) => p["age"] as int);

      expect(people.map((p) => p["age"]), [30, 25, 20]);
    });

    test('groupBy groups list based on selector', () {
      final people = [
        {"name": "Alice", "city": "Tokyo"},
        {"name": "Bob", "city": "Osaka"},
        {"name": "Charlie", "city": "Tokyo"},
      ];

      final grouped = people.groupBy((p) => p["city"]);

      expect(grouped.length, 2);
      expect(grouped["Tokyo"]!.length, 2);
      expect(grouped["Osaka"]!.length, 1);
      expect(
        grouped["Tokyo"],
        [
          {"name": "Alice", "city": "Tokyo"},
          {"name": "Charlie", "city": "Tokyo"},
        ],
      );
    });

    test('elementAtOrNull returns element when index valid', () {
      final list = ["a", "b", "c"];
      expect(list.elementAtOrNull(index: 1), "b");
    });

    test('elementAtOrNull returns null when index invalid', () {
      final list = ["a", "b", "c"];
      expect(list.elementAtOrNull(index: -1), null);
      expect(list.elementAtOrNull(index: 10), null);
    });

    test('chunked splits list into chunks of given size', () {
      final list = [1, 2, 3, 4, 5];
      final chunks = list.chunked(size: 2);

      expect(chunks, [
        [1, 2],
        [3, 4],
        [5],
      ]);
    });

    test('chunked throws error when size <= 0', () {
      final list = [1, 2, 3];
      expect(() => list.chunked(size: 0), throwsArgumentError);
      expect(() => list.chunked(size: -1), throwsArgumentError);
    });

    test('mapNotNull removes null results from transform', () {
      final input = ["1", "x", "2"];
      final output = input.mapNotNull((s) => int.tryParse(s));

      expect(output, [1, 2]);
    });

    test('mapNotNull works with mixed null and non-null mapping', () {
      final list = [1, 2, 3, 4, 5];
      final evens = list.mapNotNull((n) => n.isEven ? n : null);

      expect(evens, [2, 4]);
    });
  });
}
