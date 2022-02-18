// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:cineslide/models/models.dart';


class Solver {
  /// {@macro solver}
  Solver({required this.puzzle});

  /// Puzzle to solved
  final Puzzle puzzle;

  // These are used to find / build the solution.  They should be internal only.
  late Puzzle copy; // This won't survive!
  late List<Tile> path;

  List<Tile> solve() {

    copy = puzzle.copy();
    path = [copy.getWhitespaceTile()];

    int depth = copy.manhattanDistance();
    bool found = false;
    while (!found) {  // If it goes beyond about 6 loops, it's going to take too long to be useful.  We've got to accelerate this.
      depth = search(0, depth);
      if (copy.isComplete()) {
        found = true;
      }
    }

    return path.skip(1).toList();
  }

  /// IDA* search
  int search(int g, int bound) {
    int f = g + copy.manhattanDistance(); // h(current board)
    if (f > bound || copy.isComplete()) {
      return f;
    }

    int minimumCost = 1 << 31; // Really infinity, but good enough

    // Get all of the successors
    List<Offset> next = _nextMove();
    next.shuffle();  // This is a *little* better
    for (final Offset offset in next) {
      final Tile? tile = copy.getTileRelativeToWhitespaceTile(offset);
      assert(tile != null);
      assert(copy.isTileMovable(tile!));

      path.add(tile!); // Add the last tile to the end of the list

      copy.moveTiles(tile, []);
      f = search(g + 1, bound);
      if (copy.isComplete()) {
        return f;
      }
      if (f < minimumCost) {
        minimumCost = f;
      }

      // Undo the move
      path.removeLast(); // Not what we wanted.  Discard
      final Offset invert = Offset(-offset.dx, -offset.dy);
      final Tile? undoTile = copy.getTileRelativeToWhitespaceTile(invert);
      assert(undoTile != null);
      copy.moveTiles(undoTile!, []);
    }

    return minimumCost;
  }

  /// Iterates over possible next [Puzzle] configurations.  We don't want to
  /// allow backtracking (at least as much as we can), so use the last move
  /// to avoid sliding a tile back in the direction from which it came. That is,
  /// imagine that we have [A, B, C, WS] and the move was for WS to previously
  /// be in the position occupied by B ([A, WS, B, C]).  In this case, there are
  /// no additional moves in this row because exchanging the whitespace with
  /// either C or B would be backtracking. If instead, we have [A, B, WS, C]
  /// from [A, WS, B, C], we can move toward C, because it is not in the
  /// previous direction.
  List<Offset> _nextMove() {
    SlideDirection? disallowedDirection;
    if (path.length > 1) {
      final Position? curr = path[path.length - 1].currentPosition;
      final Position? prev = path[path.length - 2].currentPosition;

      if (curr != null && prev != null) {
        disallowedDirection = curr.directionTo(prev);
      }
    }

    final Tile whitespace = copy.getWhitespaceTile();
    List<Offset> offsets = [];
    for (final Offset offset in nextOffset(
      position: whitespace.currentPosition,
      n: copy.getDimension(),
      disallowedDirection: disallowedDirection,
    )) {
      offsets.add(offset);
    }
    return offsets;
  }
}

/// Generator that iterates through the directions and sizes to create valid
/// offsets given some puzzle configuration.  This really should be part of a
/// puzzle extension where all you need is direction and allows multiple, but
/// for now this makes it better for testing.  The solver version which doesn't
/// require more input is above.
Iterable<Offset> nextOffset({
  required Position position,
  required int n,
  SlideDirection? disallowedDirection,
  bool allowsMultiple = false,
}) sync* {
  if (disallowedDirection != SlideDirection.north) {
    if (allowsMultiple) {
      for (int i = (position.y - 1); i > 0; i--) {
        yield Offset(0, -i.toDouble());
      }
    } else {
      if (position.y > 1) {
        // Can move at least one to the north
        yield const Offset(0, -1.0);
      }
    }
  }

  if (disallowedDirection != SlideDirection.south) {
    if (allowsMultiple) {
      for (int i = (n - position.y); i > 0; i--) {
        yield Offset(0, i.toDouble());
      }
    } else {
      if (n > position.y) {
        // Can move at least one to the south
        yield const Offset(0, 1.0);
      }
    }
  }

  if (disallowedDirection != SlideDirection.west) {
    if (allowsMultiple) {
      for (int i = (position.x - 1); i > 0; i--) {
        yield Offset(-i.toDouble(), 0);
      }
    } else {
      if (position.x > 1) {
        // Can move at least one to the west
        yield const Offset(-1.0, 0);
      }
    }
  }

  if (disallowedDirection != SlideDirection.east) {
    if (allowsMultiple) {
      for (int i = (n - position.x); i > 0; i--) {
        yield Offset(i.toDouble(), 0);
      }
    } else {
      if (n > position.x) {
        // Can move at least one to the east
        yield const Offset(1.0, 0);
      }
    }
  }
}
