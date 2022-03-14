// ignore_for_file: public_member_api_docs

// Dart imports:
import 'dart:math';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:cineslide/models/models.dart';
import 'package:cineslide/settings/settings.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this.size, {this.random, this.settings}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<TileConfirmed>(_onTileConfirmed);
    on<PuzzleReset>(_onPuzzleReset);
    on<PuzzleSolve>(_onPuzzleSolve); // Compute solution
  }

  final int size;

  final Random? random;

  final SettingsBloc? settings;

   // StreamSubscription settingsSubscription;
   //
   //  settingsSubscription = settings.listen((state) {
   //    if (state is TodosLoadSuccess) {
   //      add(TodosUpdated((todosBloc.state as TodosLoadSuccess).todos));
   //    }
   //  });
  // }


  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _generatePuzzle(size, shuffle: event.shufflePuzzle);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _emitUnmovableTile(Emitter<PuzzleState> emit) {
    emit(
      state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
    );
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final bool confirmMoves = settings?.state.confirmMoves ?? false;

    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        // Move the puzzle status to pending
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (confirmMoves) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.pending,
              tileMovementStatus: TileMovementStatus.moved,
              lastTappedTile: tappedTile,
              originalWhitespaceTile: state.puzzle.getWhitespaceTile(),
            ),
          );
        } else if(puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
        return;
      }
    } else if (state.puzzleStatus == PuzzleStatus.pending) {
      // Already in the pending state.
      // Check if the current tile is even movable.
      if (state.puzzle.isTileMovable(tappedTile)) {
        final originalRow =
            state.originalWhitespaceTile?.currentPosition.y ?? -1;
        final originalColumn =
            state.originalWhitespaceTile?.currentPosition.x ?? -1;

        final Tile? currentWS = state.puzzle.getWhitespaceTile();
        final int currentWSRow = currentWS?.currentPosition.y ?? -2;
        final int currentWSColumn = currentWS?.currentPosition.x ?? -2;

        final int tappedRow = tappedTile.currentPosition.y;
        final int tappedColumn = tappedTile.currentPosition.x;

        if ((currentWSRow == originalRow &&
                currentWSColumn == originalColumn) ||
            (tappedColumn == originalColumn) ||
            (tappedRow == originalRow)) {
          // Move the puzzle status to pending
          final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
          final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              lastTappedTile: tappedTile,
            ),
          );
          return;
        }
      }
    }

    _emitUnmovableTile(emit);
  }

  void _onTileConfirmed(TileConfirmed event, Emitter<PuzzleState> emit) {
    if (state.puzzleStatus == PuzzleStatus.pending) {
      bool whitespaceMoved = state.puzzle.getWhitespaceTile().currentPosition !=
          state.originalWhitespaceTile?.currentPosition;
      int add = whitespaceMoved ? 1 : 0;

      if (state.puzzle.isComplete()) {
        emit(
          state.copyWith(
            puzzle: state.puzzle.sort(),
            puzzleStatus: PuzzleStatus.complete,
            tileMovementStatus: TileMovementStatus.moved,
            numberOfCorrectTiles: state.puzzle.getNumberOfCorrectTiles(),
            numberOfMoves: state.numberOfMoves + add,
            lastTappedTile: state.lastTappedTile,
            originalWhitespaceTile: null, // Clear
          ),
        );
      } else {
        emit(
          state.copyWith(
            puzzle: state.puzzle.sort(),
            puzzleStatus: PuzzleStatus.incomplete,
            tileMovementStatus: TileMovementStatus.moved,
            numberOfCorrectTiles: state.puzzle.getNumberOfCorrectTiles(),
            numberOfMoves: state.numberOfMoves + add,
            lastTappedTile: state.lastTappedTile,
            originalWhitespaceTile: null, // Clear
          ),
        );
      }
    } else {
      _emitUnmovableTile(emit);
    }
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) {
    final puzzle = _generatePuzzle(size);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onPuzzleSolve(PuzzleSolve event, Emitter<PuzzleState> emit) async {
    // final solver = Solver(puzzle: state.puzzle);
    // List<Tile> moves = solver.solve();

    // // Play solution...  Emit a tile every n seconds.
    // int delay = 0;
    // for (int i in [1, 2, 4, 5, 8, 9, 0]) {
    //   Future<void>.delayed(Duration(seconds: delay), () {
    //     print('$delay: swapping tile: $i');
    //     //_onTileTapped(TileTapped event, Emitter<PuzzleState> emit)
    //   });
    //   delay++;
    // }
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      // Randomize only the current tile positions.
      currentPositions.shuffle(random);
    }

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle(random);
        tiles = _getTileListFromPositions(
          size,
          correctPositions,
          currentPositions,
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }
}
