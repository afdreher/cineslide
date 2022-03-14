// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/helpers/helpers.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/tile_image_provider/tile_image_provider.dart';

abstract class _EasyTileSize {
  static double small = 100;
  static double medium = 136;
  static double large = 141;
}

abstract class _NormalTileSize {
  static double small = 75;
  static double medium = 100;
  static double large = 112;
}

abstract class _HardTileSize {
  static double small = 59;
  static double medium = 78;
  static double large = 88;
}

class AnimatedTile extends StatelessWidget {
  const AnimatedTile({
    Key? key,
    required this.size,
    required this.tile,
    required this.tileImageProvider,
    required this.theme,
    required this.movementDuration,
    required this.canPress,
    required this.scaleController,
    required this.scale,
    required this.isCorrect,
    this.isComplete = false,
    this.hasStarted = false,
    required this.cinemaAnimation,
    required AudioPlayer? audioPlayer,
  })  : _audioPlayer = audioPlayer,
        super(key: key);

  final int size;
  final Tile tile;
  final TileImageProvider tileImageProvider;
  final PuzzleTheme theme;

  final Duration movementDuration;

  final bool canPress;
  final AnimationController scaleController;
  final Animation<double> scale;

  final Animation<double>? cinemaAnimation;

  final bool isCorrect;
  final bool isComplete;
  final bool hasStarted;

  final AudioPlayer? _audioPlayer;

  @override
  Widget build(BuildContext context) {
    int size = context.read<PuzzleBloc>().size;

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
        small: (_, __, child) => SizedBox.square(
          key: Key('cinematic_puzzle_tile_small_${tile.value}'),
          dimension: size == 4
              ? _NormalTileSize.small
              : size == 3
                  ? _EasyTileSize.small
                  : _HardTileSize.small,
          child: child,
        ),
        medium: (_, __, child) => SizedBox.square(
          key: Key('cinematic_puzzle_tile_medium_${tile.value}'),
          dimension: size == 4
              ? _NormalTileSize.medium
              : size == 3
                  ? _EasyTileSize.medium
                  : _HardTileSize.medium,
          child: child,
        ),
        large: (_, __, child) => SizedBox.square(
          key: Key('cinematic_puzzle_tile_large_${tile.value}'),
          dimension: size == 4
              ? _NormalTileSize.large
              : size == 3
                  ? _EasyTileSize.large
                  : _HardTileSize.large,
          child: child,
        ),
        child: (_) => MouseRegion(
          onEnter: (_) {
            if (canPress) {
              scaleController.forward();
            }
          },
          onExit: (_) {
            if (canPress) {
              scaleController.reverse();
            }
          },
          child: ScaleTransition(
            key: Key('cinematic_puzzle_tile_scale_${tile.value}'),
            scale: scale,
            child: CinematicPuzzleTileButton(
              key: Key('cinematic_puzzle_tile_${tile.value}_button'),
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
              child: _animationWidget(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _animationWidget(BuildContext context) {
    final Animation<double>? animation = cinemaAnimation;

    final Key key = Key('animated_cinematic_puzzle_tile_${tile.value}');

    if (hasStarted && tile.isWhitespace && !isComplete) {
      return Container();
    }

    if (!hasStarted || animation == null || !isCorrect) {
      return _ResponsiveTile(
          key: key,
          value: tile.value,
          image: tileImageProvider.imageFor(tile: tile.value, frame: 0));
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return _ResponsiveTile(
            key: key,
            value: tile.value,
            image: tileImageProvider.relativeImageFor(
                tile: tile.value, relativeFrame: animation.value));
      },
    );
  }
}

class _ResponsiveTile extends StatelessWidget {
  const _ResponsiveTile({Key? key, required this.value, this.image})
      : super(key: key);

  final int value;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    int size = context.read<PuzzleBloc>().size;

    return ResponsiveLayoutBuilder(
      small: (_, __, child) => SizedBox.square(
        key: Key('responsive_cinematic_puzzle_tile_image_small_$value'),
        dimension: size == 4
              ? _NormalTileSize.small
              : size == 3
                  ? _EasyTileSize.small
                  : _HardTileSize.small,
        child: child,
      ),
      medium: (_, __, child) => SizedBox.square(
        key: Key('responsive_cinematic_puzzle_tile_image_medium_$value'),
        dimension: size == 4
              ? _NormalTileSize.medium
              : size == 3
                  ? _EasyTileSize.medium
                  : _HardTileSize.medium,
        child: child,
      ),
      large: (_, __, child) => SizedBox.square(
        key: Key('responsive_cinematic_puzzle_tile_image_large_$value'),
        dimension: size == 4
              ? _NormalTileSize.large
              : size == 3
                  ? _EasyTileSize.large
                  : _HardTileSize.large,
        child: child,
      ),
      child: (_) => image == null
          ? Container()
          : FittedBox(
              child: image,
              fit: BoxFit.fill,
            ),
    );
  }
}
