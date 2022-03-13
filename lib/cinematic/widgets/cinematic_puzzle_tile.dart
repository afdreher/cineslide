// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/helpers/helpers.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/tile_image_provider/tile_image_provider.dart';


/// {@template cinematic_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
class CinematicPuzzleTile extends StatefulWidget {
  /// {@macro cinematic_puzzle_tile}
  const CinematicPuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
    required this.tileImageProvider,
    this.cinemaAnimation,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The tile image provider
  final TileImageProvider tileImageProvider;
  final Animation<double>? cinemaAnimation;

  /// The state of the puzzle.
  final PuzzleState state;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<CinematicPuzzleTile> createState() => CinematicPuzzleTileState();

  // void animationUpdated() {
  //   //print('Animate');
  // }
}

/// The state of [CinematicPuzzleTile].
@visibleForTesting
class CinematicPuzzleTileState extends State<CinematicPuzzleTile>
    with SingleTickerProviderStateMixin {
  AudioPlayer? _audioPlayer;
  late final Timer _timer;

  /// The controller that drives [_scaleAnimation] animation.
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: PuzzleThemeAnimationDuration.puzzleTileScale,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    // Delay the initialization of the audio player for performance reasons,
    // to avoid dropping frames when the theme is changed.
    _timer = Timer(const Duration(seconds: 1), () {
      _audioPlayer = widget._audioPlayerFactory()
        ..setAsset('assets/audio/tile_move.mp3');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.state.puzzle.getDimension();
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final status =
        context.select((CinematicPuzzleBloc bloc) => bloc.state.status);
    final hasStarted = status == CinematicPuzzleStatus.started;

    final puzzleStatus = context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus);
    final puzzleIncomplete = puzzleStatus == PuzzleStatus.incomplete;
    final puzzlePending = puzzleStatus == PuzzleStatus.pending;
    final isComplete = puzzleStatus == PuzzleStatus.complete;

    final movementDuration = status == CinematicPuzzleStatus.loading
        ? const Duration(milliseconds: 800)
        : const Duration(milliseconds: 370);

    final canPress = hasStarted && (puzzleIncomplete || puzzlePending) && !widget.tile.isWhitespace;

    final isCorrect = widget.tile.isInCorrectPosition;

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedTile(
          tile: widget.tile,
          tileImageProvider: widget.tileImageProvider,
          theme: theme,
          size: size,
          movementDuration: movementDuration,
          canPress: canPress,
          scaleController: _scaleController,
          scale: _scaleAnimation,
          isCorrect: isCorrect,
          isComplete: isComplete,
          hasStarted: hasStarted,
          cinemaAnimation: widget.cinemaAnimation,
          audioPlayer: _audioPlayer),
    );
  }
}
