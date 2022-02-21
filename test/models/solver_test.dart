// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cineslide/models/models.dart';

/// Matcher to test whether an offset is NORTH (UP)
final isNorth = const TypeMatcher<Offset>()
    .having((e) => e.dx, "x should be 0", equals(0))
    .having((e) => e.dy, "y should be negative", isNegative);

/// Matcher to test whether an offset is SOUTH (DOWN)
final isSouth = const TypeMatcher<Offset>()
    .having((e) => e.dx, "x should be 0", equals(0))
    .having((e) => e.dy, "y should be positive", isPositive);

/// Matcher to test whether an offset is WEST (LEFT)
final isWest = const TypeMatcher<Offset>()
    .having((e) => e.dx, "x should be negative", isNegative)
    .having((e) => e.dy, "y should be 0", equals(0));

/// Matcher to test whether an offset is EAST (RIGHT)
final isEast = const TypeMatcher<Offset>()
    .having((e) => e.dx, "x should be positive", isPositive)
    .having((e) => e.dy, "y should be 0", equals(0));

/// Function that tests a generator [g] against a list of matchers [s].  The
/// list of matchers is expected to be exhaustive such that the generator will
/// provide exactly that number of items.
void matchesSequence<T>(Iterable<T> g, List<Matcher> s) {
  Iterator<T> it = g.iterator;
  for (Matcher m in s) {
    expect(it.moveNext(), isTrue);
    expect(it.current, m);
  }

  // There should be no further options
  expect(it.moveNext(), isFalse);
}

void main() {
  group('solutions', () {
    group('super easy', () {
      test('solved puzzle', () {
        final Puzzle test3x3Puzzle = Puzzle.fromValues(values: const [
          1, 2, 3, //
          4, 5, 6, //
          7, 8, 0, //
        ]);

        final Solver solver = Solver(puzzle: test3x3Puzzle);
        List<Tile> solution = solver.solve();

        expect(solution.length, equals(0));
      });

      test('super easy puzzle with 1 move', () {
        final Puzzle test3x3Puzzle = Puzzle.fromValues(values: const [
          1, 2, 3, //
          4, 5, 6, //
          7, 0, 8, //
        ]);

        final Solver solver = Solver(puzzle: test3x3Puzzle);
        List<Tile> solution = solver.solve();

        expect(solution.length, equals(1));
      });

      test('super easy puzzle with 3 moves', () {
        final Puzzle test3x3Puzzle = Puzzle.fromValues(values: const [
          1, 2, 3, //
          0, 4, 6, //
          7, 5, 8, //
        ]);

        final Solver solver = Solver(puzzle: test3x3Puzzle);
        List<Tile> solution = solver.solve();

        expect(solution.length, equals(3));
      });

      test('super easy puzzle with 1 multi-move', () {
        final Puzzle test3x3Puzzle = Puzzle.fromValues(values: const [
          1, 2, 0, //
          4, 5, 3, //
          7, 8, 6, //
        ]);

        final Solver solver = Solver(puzzle: test3x3Puzzle);
        List<Tile> solution = solver.solve();

        expect(solution.length, equals(2));
      });

      test('super easy puzzle with 2 multi-moves sliding east', () {
        final Puzzle test3x3Puzzle = Puzzle.fromValues(values: const [
          1, 2, 3, //
          4, 5, 6, //
          0, 7, 8, //
        ]);

        final Solver solver = Solver(puzzle: test3x3Puzzle);
        List<Tile> solution = solver.solve();

        expect(solution.length, equals(2));
      });

      test('super easy puzzle with 2 multi-moves as edges', () {
        final Puzzle test3x3Puzzle = Puzzle.fromValues(values: const [
          0, 1, 2, //
          4, 5, 3, //
          7, 8, 6, //
        ]);

        final Solver solver = Solver(puzzle: test3x3Puzzle);
        List<Tile> solution = solver.solve();

        expect(solution.length, equals(4));
      });
    });

  group('moderate', () {
    test('moderate puzzle', () {
      final Puzzle test4x4Puzzle = Puzzle.fromValues(values: const [
        1, 9, 8, 6, //
        14, 15, 0, 3, //
        12, 5, 13, 2, //
        7, 10, 11, 4, //
      ]);

      final Solver solver = Solver(puzzle: test4x4Puzzle);
      List<Tile> solution = solver.solve();

      expect(solution.length, equals(47));
    });

    test('moderately hard puzzle', () {
      final Puzzle test4x4Puzzle = Puzzle.fromValues(values: const [
        5, 12, 2, 10, //
        1, 7, 13, 3, //
        6, 15, 14, 11, //
        0, 8, 9, 4, //
      ]);

      final Solver solver = Solver(puzzle: test4x4Puzzle);
      List<Tile> solution = solver.solve();

      expect(solution.length, equals(51));
    });
  });

    // This one takes way too long...
    test('hard puzzle', () {
      final Puzzle test4x4Puzzle = Puzzle.fromValues(values: const [
        7, 11, 5, 13, //
        6, 14, 3, 9, //
        2, 8, 4, 10, //
        12, 1, 15, 0, //
      ]);

      final Solver solver = Solver(puzzle: test4x4Puzzle);
      List<Tile> solution = solver.solve();

      expect(solution.length, equals(60));
    });


  });

  group('offsets', () {
    test('single offsets in upper left corner', () {
      Iterable<Offset> g = nextOffset(position: const Position(x: 1, y: 1), n: 4);
      matchesSequence(g, [isSouth, isEast]);
    });

    test('single offsets in center', () {
      Iterable<Offset> g = nextOffset(position: const Position(x: 2, y: 2), n: 4);
      matchesSequence(g, [isNorth, isSouth, isWest, isEast]);
    });

    test('single offsets in center banning north', () {
      Iterable<Offset> g = nextOffset(
          position: const Position(x: 2, y: 2),
          n: 4,
          disallowedDirection: SlideDirection.north);
      matchesSequence(g, [isSouth, isWest, isEast]);
    });

    test('single offsets in center banning south', () {
      Iterable<Offset> g = nextOffset(
          position: const Position(x: 2, y: 2),
          n: 4,
          disallowedDirection: SlideDirection.south);
      matchesSequence(g, [isNorth, isWest, isEast]);
    });

    test('single offsets in center banning west', () {
      Iterable<Offset> g = nextOffset(
          position: const Position(x: 2, y: 2),
          n: 4,
          disallowedDirection: SlideDirection.west);
      matchesSequence(g, [isNorth, isSouth, isEast]);
    });

    test('single offsets in center banning east', () {
      Iterable<Offset> g = nextOffset(
          position: const Position(x: 2, y: 2),
          n: 4,
          disallowedDirection: SlideDirection.east);
      matchesSequence(g, [isNorth, isSouth, isWest]);
    });
  });
}
