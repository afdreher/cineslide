// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themed/themed.dart';

// Project imports:
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/corner_triangle/corner_triangle.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/settings/settings.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/typography/typography.dart';

class CinematicPuzzleTileButton extends StatelessWidget {
  CinematicPuzzleTileButton(
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
        tween: isCorrect ? _forwardTween : _reverseTween,
        duration: duration,
        curve: isCorrect ? Curves.easeIn : Curves.ease,
        builder: (_, double value, Widget? child) {
          if (child == null) {
            return Container();
          }
          return ChangeColors(
            saturation: value,
            child: child,
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
      child: OutlinedButton(  // TODO: Animate shrinkage
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
                  if (!context.read<SettingsBloc>().state.showTileNumbers || tile.isWhitespace) {
                    return Container();
                  }
                  return _BlurredCornerTriangle(
                      theChild: theChild, theme: theme, tile: tile, opacity: 0.2,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Create a blurry triangle in the upper left corner
class _BlurredCornerTriangle extends StatelessWidget {
  const _BlurredCornerTriangle({
    Key? key,
    required this.theChild,
    required this.theme,
    required this.tile,
    this.sigma = 5.0,
    this.opacity = 0.25,
  }) : super(key: key);

  final Widget? theChild;
  final PuzzleTheme theme;
  final Tile tile;
  final double sigma;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipBehavior: Clip.antiAlias,
          clipper: const CornerTriangleClipper(
            corner: Corner.topLeft,
          ),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: theChild,
          ),
        ),
        FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: CornerTriangle(
            clipBehavior: Clip.antiAlias,
            corner: Corner.topLeft,
            color: theme.defaultColor.withOpacity(opacity),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: OutlinedText(
                tile.value.toString(),
                style: TextStyle(color: theme.titleColor),
                strokeColor: theme.defaultColor,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
