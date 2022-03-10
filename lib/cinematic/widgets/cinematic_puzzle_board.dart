// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/helpers/helpers.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/timer/timer.dart';
import 'package:cineslide/tile_image_provider/tile_image_provider.dart';
import 'package:cineslide/theme/theme.dart';

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template cinematic_puzzle_board}
/// Displays the board of the puzzle in a [Stack] filled with [tiles].
/// {@endtemplate}
class CinematicPuzzleBoard extends StatefulWidget {
  /// {@macro cinematic_puzzle_board}
  const CinematicPuzzleBoard({
    Key? key,
    required this.tiles,
    required this.tileImageProvider,
  }) : super(key: key);

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;
  final TileImageProvider tileImageProvider;

  @override
  State<CinematicPuzzleBoard> createState() => _CinematicPuzzleBoardState();
}

class _CinematicPuzzleBoardState extends State<CinematicPuzzleBoard>
    with SingleTickerProviderStateMixin {
  Timer? _completePuzzleTimer;

  // The animation will always be running for the board.  This isn't especially
  // efficient, but I don't care right now.
  late final AnimationController _cinemaController;
  late final Animation<double> cinemaAnimation;

  @override
  void initState() {
    super.initState();

    // Create the animation controller
    _cinemaController = AnimationController(vsync: this, duration: widget.tileImageProvider.duration);
    //cinemaAnimation = Tween<double>(begin: 0.0, end: widget.tileImageProvider.frameCount - 1).animate(_cinemaController);
    cinemaAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_cinemaController);
    _cinemaController.repeat();
  }

  @override
  void dispose() {
    _completePuzzleTimer?.cancel();
    _cinemaController.dispose();

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
