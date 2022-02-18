// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cineslide/models/models.dart';

void main() {
  group('manhattan distance', () {
    test('solved puzzle MD', () {
      final test3x3Puzzle = Puzzle.fromValues(values: const [
         1, 2, 3,
         4, 5, 6,
         7, 8, 0
      ]);

      expect(test3x3Puzzle.manhattanDistance(), equals(0));
    });

    test('super easy puzzle with 1 move MD', () {
      final test3x3Puzzle = Puzzle.fromValues(values: const [
         1, 2, 3,
         4, 5, 6,
         7, 0, 8,
      ]);

      expect(test3x3Puzzle.manhattanDistance(), equals(1));
    });

    test('super easy puzzle with 3 moves MD', () {
      final test3x3Puzzle = Puzzle.fromValues(values: const [
         1, 2, 3,
         0, 4, 6,
         7, 5, 8,
      ]);

      expect(test3x3Puzzle.manhattanDistance(), equals(3));
    });

    test('super easy puzzle with 1 multi-move MD', () {
      final test3x3Puzzle = Puzzle.fromValues(values: const [
         1, 2, 0,
         4, 5, 3,
         7, 8, 6,
      ]);

      expect(test3x3Puzzle.manhattanDistance(), equals(2));
    });

    test('super easy puzzle with 2 multi-moves sliding east MD', () {
      final test3x3Puzzle = Puzzle.fromValues(values: const [
         1, 2, 3,
         4, 5, 6,
         0, 7, 8,
      ]);

      expect(test3x3Puzzle.manhattanDistance(), equals(2));
    });

    test('super easy puzzle with 2 multi-moves as edges MD', () {
      final test3x3Puzzle = Puzzle.fromValues(values: const [
         0, 1, 2,
         4, 5, 3,
         7, 8, 6,
      ]);

      expect(test3x3Puzzle.manhattanDistance(), equals(4));
    });

  // These don't work.  Something isn't quite right...
    test('moderate puzzle MD', () {
      final test4x4Puzzle = Puzzle.fromValues(values: const [
         1,  9,  8, 6,    // 0 + 3 + 2 + 3
        14, 15,  0, 3,    // 3 + 3 + 0 + 2
        12,  5, 13, 2,    // 3 + 2 + 3 + 4
         7, 10, 11, 4,    // 4 + 1 + 1 + 3
      ]);

      expect(test4x4Puzzle.manhattanDistance(), equals(37));
    });

     test('hard puzzle MD', () {
       final test4x4Puzzle = Puzzle.fromValues(values: const [
         7, 11,  5, 13,    // 3 + 3 + 3 + 6
         6, 14,  3,  9,    // 1 + 2 + 1 + 4
         2,  8,  4, 10,    // 3 + 3 + 3 + 2
        12,  1, 15,  0,    // 4 + 4 + 0 + 0
       ]);

       expect(test4x4Puzzle.manhattanDistance(), equals(42));
    });

     test('moderately hard puzzle MD', () {
       final test4x4Puzzle = Puzzle.fromValues(values: const [
         5, 12,  2, 10,    // 1 + 4 + 1 + 4
         1,  7, 13,  3,    // 1 + 1 + 4 + 2
         6, 15, 14, 11,    // 2 + 2 + 2 + 1
         0,  8,  9,  4,    // 0 + 4 + 3 + 3
       ]);

       expect(test4x4Puzzle.manhattanDistance(), equals(35));
    });
  });
}
