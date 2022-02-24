// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:themed/themed.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/dashatar/dashatar.dart';
import 'package:cineslide/helpers/helpers.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/themes/themes.dart';
import 'package:cineslide/typography/text_styles.dart';
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/settings/settings.dart';
import 'package:cineslide/corner_triangle/corner_triangle.dart';
import 'package:cineslide/typography/outlined_text.dart';

abstract class _TileSize {
  static double small = 75;
  static double medium = 100;
  static double large = 112;
}

/// {@template dashatar_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
class DashatarPuzzleTile extends StatefulWidget {
  /// {@macro dashatar_puzzle_tile}
  const DashatarPuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarPuzzleTile> createState() => DashatarPuzzleTileState();
}

/// The state of [DashatarPuzzleTile].
@visibleForTesting
class DashatarPuzzleTileState extends State<DashatarPuzzleTile>
    with SingleTickerProviderStateMixin {
  AudioPlayer? _audioPlayer;
  late final Timer _timer;

  /// The controller that drives [_scale] animation.
  late AnimationController _controller;
  late Animation<double> _scale;

  /// [Animation] to desaturate the tile color
  late Animation<double> _decolorize;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: PuzzleThemeAnimationDuration.puzzleTileScale,
    );

    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    _decolorize = Tween<double>(begin: 0.0, end: -0.95).animate(
      CurvedAnimation(
        parent: _controller,
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
    final theme = context.select((DashatarThemeBloc bloc) => bloc.state.theme);
    final status =
        context.select((DashatarPuzzleBloc bloc) => bloc.state.status);
    final hasStarted = status == DashatarPuzzleStatus.started;
    final puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;
    final puzzlePending =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.pending;

    final movementDuration = status == DashatarPuzzleStatus.loading
        ? const Duration(milliseconds: 800)
        : const Duration(milliseconds: 370);

    final canPress = hasStarted && (puzzleIncomplete || puzzlePending);

    final isCorrect = widget.tile.isInCorrectPosition;

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedTile(
          tile: widget.tile,
          size: size,
          movementDuration: movementDuration,
          canPress: canPress,
          controller: _controller,
          scale: _scale,
          theme: theme,
          isCorrect: isCorrect,
          audioPlayer: _audioPlayer),
    );
  }
}

class AnimatedTile extends StatelessWidget {
  const AnimatedTile({
    Key? key,
    required this.size,
    required this.tile,
    required this.movementDuration,
    required this.canPress,
    required this.controller,
    required this.scale,
    required this.theme,
    required this.isCorrect,
    required AudioPlayer? audioPlayer,
  })  : _audioPlayer = audioPlayer,
        super(key: key);

  final int size;
  final Tile tile;
  final Duration movementDuration;

  final bool canPress;
  final AnimationController controller;

  final Animation<double> scale;

  final DashatarTheme theme;
  final bool isCorrect;
  final AudioPlayer? _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      // The AnimatedAlign is responsible for the animated 'shift' in the tile
      // pieces.  This should probably be replaced with an animated build to
      // transition both the position and the color / animation.  However,
      // the onEnd may be sufficient to start playing / transitioning the color
      alignment: FractionalOffset(
        (tile.currentPosition.x - 1) / (size - 1),
        (tile.currentPosition.y - 1) / (size - 1),
      ),
      duration: movementDuration,
      curve: Curves.easeInOut,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_small_${tile.value}'),
          dimension: _TileSize.small,
          child: child,
        ),
        medium: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_medium_${tile.value}'),
          dimension: _TileSize.medium,
          child: child,
        ),
        large: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_large_${tile.value}'),
          dimension: _TileSize.large,
          child: child,
        ),
        child: (_) => MouseRegion(
          onEnter: (_) {
            if (canPress) {
              controller.forward();
            }
          },
          onExit: (_) {
            if (canPress) {
              controller.reverse();
            }
          },
          child: ScaleTransition(
            key: Key('dashatar_puzzle_tile_scale_${tile.value}'),
            scale: scale,
            child: PuzzleTileButton(
              key: Key('dashatar_puzzle_tile_${tile.value}_button'),
              tile: tile,
              theme: theme,
              duration: movementDuration,
              isCorrect: isCorrect,
              onPressed: canPress
                  ? () {
                      context.read<PuzzleBloc>().add(TileTapped(tile));
                      unawaited(_audioPlayer?.replay());
                    }
                  : null,
              child: Image.asset(
                theme.dashAssetForTile(tile),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PuzzleTileButton extends StatelessWidget {
  PuzzleTileButton(
      {Key? key,
      required this.tile,
      required this.theme,
      this.isCorrect = false,
      this.onPressed,
      required this.duration,
      this.child})
      : childKey = Key('puzzle_tile_${tile.value}_animation'),
        super(key: key);

  final Tile tile;

  final PuzzleTheme theme;
  final bool isCorrect;

  final Duration duration;

  final VoidCallback? onPressed;
  final Key childKey;

  final Widget? child;

  final _forwardTween = Tween<double>(begin: -0.95, end: 0.0);
  final _reverseTween = Tween<double>(begin: 0.0, end: -0.95);

  @override
  Widget build(BuildContext context) {
    Widget? theChild = child;
    if (theChild != null) {
      // Animate this change!
      theChild = TweenAnimationBuilder(
        key: childKey,
        child: theChild,
        tween: isCorrect
            ? _forwardTween
            : _reverseTween,
        duration: duration,
        builder: (_, double value, Widget? myChild) {
          return ChangeColors(
            saturation: value,
            child: myChild!,
          );
        },
      );
    }

    return Semantics(
      button: true,
      label: context.l10n.puzzleTileLabelText(
        tile.value.toString(),
        tile.currentPosition.x.toString(),
        tile.currentPosition.y.toString(),
      ),
      child: OutlinedButton(
        clipBehavior: Clip.antiAlias,
        style: TextButton.styleFrom(
          primary: PuzzleColors.white,
          textStyle: PuzzleTextStyle.bodySmall,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          padding: EdgeInsets.zero,
          alignment: Alignment.topLeft,
        ),
        onPressed: onPressed,
        child: Stack(
          children: <Widget>[
            if (theChild != null) theChild,
            FractionallySizedBox(
              heightFactor: 0.9,
              widthFactor: 0.9,
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (!context.read<SettingsBloc>().state.showTileNumbers) {
                    return Container();
                  }
                  return Stack(
                    children: [
                      ClipPath(
                        clipBehavior: Clip.antiAlias,
                        clipper: CornerTriangleClipper(
                          corner: Corner.topLeft,
                        ),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: theChild,
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: CornerTriangle(
                          clipBehavior: Clip.antiAlias,
                          corner: Corner.topLeft,
                          color: theme.titleColor.withOpacity(0.25),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: OutlinedText(
                              tile.value.toString(),
                              style: TextStyle(color: theme.titleColor),
                              strokeColor: theme.backgroundColor,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
