// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:cineslide/tile_image_provider/tile_image_provider.dart';
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

abstract class _TileSize {
  static double small = 75;
  static double medium = 100;
  static double large = 112;
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
        small: (_, __, child) => SizedBox.square(
          key: Key('cinematic_puzzle_tile_small_${tile.value}'),
          dimension: _TileSize.small,
          child: child,
        ),
        medium: (_, __, child) => SizedBox.square(
          key: Key('cinematic_puzzle_tile_medium_${tile.value}'),
          dimension: _TileSize.medium,
          child: child,
        ),
        large: (_, __, child) => SizedBox.square(
          key: Key('cinematic_puzzle_tile_large_${tile.value}'),
          dimension: _TileSize.large,
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
              tileImageProvider: tileImageProvider,
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
    Image? img;
    if (isCorrect && animation != null) {
      img = tileImageProvider.relativeImageFor(
              tile: tile.value, relativeFrame: animation.value);
    } else {
      img = tileImageProvider.imageFor(tile: tile.value, frame: 0);
    }

    if (img == null) {
      return Container();
    }

    final tiled = ResponsiveLayoutBuilder(
          small: (_, __, child) => SizedBox.square(
            key: Key('cinematic_puzzle_tile_image_small_${tile.value}'),
            dimension: _TileSize.small,
            child: child,
          ),
          medium: (_, __, child) => SizedBox.square(
            key: Key('cinematic_puzzle_tile_image_medium_${tile.value}'),
            dimension: _TileSize.medium,
            child: child,
          ),
          large: (_, __, child) => SizedBox.square(
            key: Key('cinematic_puzzle_tile_image_large_${tile.value}'),
            dimension: _TileSize.large,
            child: child,
          ),
          child: (_) => FittedBox(
            child: img,
            fit: BoxFit.fill,
          ),
        );

    if (animation == null) {
      return tiled;
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return tiled;
      },
    );
  }
}
