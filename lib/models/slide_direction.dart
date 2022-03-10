// Project imports:
import 'package:cineslide/models/models.dart';

enum SlideDirection { north, south, east, west }

extension Inversion on SlideDirection {
  /// Get the opposing direction.  It's not complicated; it's not supposed to be.
  SlideDirection inverse() {
    switch (this) {
      case SlideDirection.north:
        return SlideDirection.south;
      case SlideDirection.south:
        return SlideDirection.north;
      case SlideDirection.east:
        return SlideDirection.west;
      case SlideDirection.west:
        return SlideDirection.east;
    }
  }
}

extension Direction on Position {
  /// Get the direction one would have to slide from [this] to [other].  For
  /// example, if the current position's x is 2, and the other position's x is
  /// 4, this means that the position must slide 2 units over to the east.
  ///
  /// This method will return null if the positions are either the same or if
  /// the difference is not along a cardinal direction.
  SlideDirection? directionTo(Position other) {
    final int dx = other.x - x;
    final int dy = other.y - y;

    if (dx != 0 && dy == 0) {
      // Horizontal slide
      return dx > 0 ? SlideDirection.east : SlideDirection.west;
    } else if (dx == 0 && dy != 0) {
      // Vertical slide
      return dy > 0 ? SlideDirection.south : SlideDirection.north;
    }

    // Either there is no slide or it is not along a cardinal direction
    return null;
  }
}
