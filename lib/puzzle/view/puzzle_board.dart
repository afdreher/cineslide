// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/tile_image_provider/tile_image_provider.dart';
import 'package:cineslide/timer/timer.dart';

import '../../helpers/modal_helper.dart';


abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
@visibleForTesting

/// {@template cinematic_puzzle_board}
/// Displays the board of the puzzle in a [Stack] filled with [tiles].
/// {@endtemplate}
class PuzzleBoard extends StatefulWidget {
  /// {@macro cinematic_puzzle_board}
  const PuzzleBoard({
    Key? key,
    required this.tileImageProvider,
  }) : super(key: key);

  final TileImageProvider tileImageProvider;

  @override
  State<PuzzleBoard> createState() => _PuzzleBoard();
}

class _PuzzleBoard extends State<PuzzleBoard>
    with SingleTickerProviderStateMixin {

  // The animation will always be running for the board.  This isn't especially
  // efficient, but I don't care right now.
  late final AnimationController _cinemaController;
  late final Animation<double> cinemaAnimation;

  @override
  void initState() {
    super.initState();

    // Create the animation controller
    _cinemaController = AnimationController(
        vsync: this, duration: widget.tileImageProvider.duration);
    //cinemaAnimation = Tween<double>(begin: 0.0, end: widget.tileImageProvider.frameCount - 1).animate(_cinemaController);
    cinemaAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_cinemaController);
    _cinemaController.repeat();
  }

  @override
  void dispose() {
    _cinemaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final puzzle = state.puzzle;

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return PuzzleKeyboardHandler(
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
            context.read<TimerBloc>().add(const TimerStopped());
          }
        },
        child: CinematicBoardBuilder(
          animation: cinemaAnimation,
          tileImageProvider: widget.tileImageProvider,
          size: size,
          tiles: puzzle.tiles
              .map(
                (tile) => CinematicPuzzleTile(
                  key: Key('puzzle_tile_${tile.value.toString()}'),
                  tile: tile,
                  state: state,
                  tileImageProvider: widget.tileImageProvider,
                  cinemaAnimation: cinemaAnimation,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class CinematicBoardBuilder extends StatelessWidget {
  const CinematicBoardBuilder(
      {Key? key,
      required this.animation,
      required this.tileImageProvider,
      required this.size,
      required this.tiles})
      : super(key: key);

  final Animation<double> animation;
  final TileImageProvider tileImageProvider;

  final int size;
  final List<CinematicPuzzleTile> tiles;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: ResponsiveLayoutBuilder(
            small: (_, __, child) => const SizedBox(),
            medium: (_, __, child) => const SizedBox(),
            large: (_, __, child) => const CinematicTimer(),
          ),
        ),
        Column(
          children: [
            const ResponsiveGap(
              small: 21,
              medium: 34,
              large: 96,
            ),
            CinematicPuzzleBoard(
              tiles: tiles,
            ),
            const ResponsiveGap(
              large: 96,
            ),
          ],
        ),
      ],
    );
  }
}

class CinematicPuzzleBoard extends StatefulWidget {
  const CinematicPuzzleBoard({Key? key, required this.tiles}) : super(key: key);

  final List<CinematicPuzzleTile> tiles;

  @override
  State<CinematicPuzzleBoard> createState() => _CinematicPuzzleBoard();
}

class _CinematicPuzzleBoard extends State<CinematicPuzzleBoard> {
  Timer? _completePuzzleTimer;

  @override
  void dispose() {
    _completePuzzleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) async {
        if (state.puzzleStatus == PuzzleStatus.complete) {
          _completePuzzleTimer =
              Timer(const Duration(milliseconds: 370), () async {
            await showAppDialog<void>(
              context: context,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<ThemeBloc>(),
                  ),
                  BlocProvider.value(
                    value: context.read<PuzzleBloc>(),
                  ),
                  BlocProvider.value(
                    value: context.read<TimerBloc>(),
                  ),
                  BlocProvider.value(
                    value: context.read<AudioControlBloc>(),
                  ),
                ],
                child: const CinematicShareDialog(),
              ),
            );
          });
        }
      },
      child: ResponsiveLayoutBuilder(
        small: (_, __, child) => SizedBox.square(
          key: const Key('cinematic_puzzle_board_small'),
          dimension: _BoardSize.small,
          child: child,
        ),
        medium: (_, __, child) => SizedBox.square(
          key: const Key('cinematic_puzzle_board_medium'),
          dimension: _BoardSize.medium,
          child: child,
        ),
        large: (_, __, child) => SizedBox.square(
          key: const Key('cinematic_puzzle_board_large'),
          dimension: _BoardSize.large,
          child: child,
        ),
        child: (_) => Stack(children: widget.tiles),
      ),
    );
  }
}
