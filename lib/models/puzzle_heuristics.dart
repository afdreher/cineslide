// Project imports:
import 'package:cineslide/models/puzzle.dart';

extension Heuristics on Puzzle {
  // SEE: https://michael.kim/blog/puzzle for details on different possible
  // heuristics

  /// Computes the total manhattan distance for a [Puzzle]
  ///
  /// Note that the manhattan distance is fine for 1-move solutions, but has to
  /// be modified for multiple move ones, since it would otherwise overestimate
  /// the distance.
  ///
  /// Example:
  ///     1 2 3       1 2 3
  ///     4 5 6   ->  4 5 6
  ///     _ 7 8       7 8 _
  ///
  /// This puzzle is solvable in 1 move by requesting the whitespace move to the
  /// far right (east) of the board.  This yields [7, 8, _] as the bottom row,
  /// which is the solution. The manhattan distance, however, is 2, making the
  /// heuristic inadmissible.
  int manhattanDistance() {
    return tiles.fold(0, (prev, element) {
      if (element.isWhitespace) {
        return prev;
      }
      return prev + element.manhattanDistance;
    });
  }

  /// Use the multi-tile walking distance metric to solve for the puzzle where
  /// you are allowed to slide any number of tiles on a row.
  ///
  /// The basic idea is to start at the solved state, and walk backwards using
  /// BFS to find the available patterns.  In the solved state, the number of
  /// tiles in the row and column in the correct positions are equivalent.
  // int walkingDistance() {
  //   // Note, this should be cached and pulled from storage.  The pre-computation
  //   // takes time, but the actual solutions should be a bit faster.
  //
  //   // This is not as fast as a pattern DB, but it is a lot smaller -- it's
  //   // small enough to easily put client side on mobile or web.  The DB version
  //   // isn't.
  //
  // }
  //
  // const int UP = 1;
  // const int DOWN = -1;
  //
  // void explore(int space_idx, walking_distance, direction) {
  //   // Given a space index, explore all the possible moves in direction, setting
  //   // the distance and extending the tdnx table.
  //   int tile_idx = space_idx + direction;
  //
  //   for (int group = 1; group < SIZE; group++) {
  //     if (wdkey[tile_idx][group]) {
  //       // ie: check row tile_idx for tiles belonging to rows 1..4
  //       // Swap one of those tiles with the space
  //       wdkey[tile_idx][group] -= 1;
  //       wdkey[space_idx][group] += 1;
  //
  //       if (getd_index(wdkey, mmwd) == 0) {
  //         // save the walking distance value
  //         setd(wdkey, walking_distance + 1, mmwd);
  //         //and add to the todo next list:
  //         assert(getd_index(wdkey, tdnx) == 0);
  //         setd(wdkey, {walking_distance + 1, tile_idx}, tdnx);
  //       }
  //
  //       if (MTM) {
  //         if (tile_idx > 1 && tile_idx < SIZE) {
  //           //mtm: same direction means same distance:
  //           explore(tile_idx, walking_distance, direction);
  //         }
  //       } // End IF MTM
  //
  //       // Revert the swap so we can look at the next candidate.
  //       wdkey[tile_idx][group] += 1
  //       wdkey[space_idx][group] -= 1
  //     }
  //   }
  // }

}
