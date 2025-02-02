// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/typography/typography.dart';

/// {@template cinematic_score}
/// Displays the score of the solved Cinematic puzzle.
/// {@endtemplate}
class CinematicScore extends StatelessWidget {
  /// {@macro cinematic_score}
  const CinematicScore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeBloc>().state.theme;
    final state = context.watch<PuzzleBloc>().state;
    final l10n = context.l10n;

    return ResponsiveLayoutBuilder(
      small: (_, __, child) => child!,
      medium: (_, __, child) => child!,
      large: (_, __, child) => child!,
      child: (currentSize) {
        final height =
            currentSize == ResponsiveLayoutSize.small ? 374.0 : 355.0;

        final completedTextWidth =
            currentSize == ResponsiveLayoutSize.small ? 160.0 : double.infinity;

        final wellDoneTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline4Soft
            : PuzzleTextStyle.headline3;

        final timerTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline5
            : PuzzleTextStyle.headline4;

        final timerIconSize = currentSize == ResponsiveLayoutSize.small
            ? const Size(21, 21)
            : const Size(28, 28);

        final timerIconPadding =
            currentSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

        final numberOfMovesTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline5
            : PuzzleTextStyle.headline4;

        return ClipRRect(
          key: const Key('cinematic_score'),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: height,
            height: height,
            color: theme.backgroundColor,
            child: Stack(
              children: [
                BlurredSuccessBackground(
                  sigma: 15.0,
                  topOffset: height * 0.8,
                  bottomOffset: height * 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fill,
                      image: Image.asset(
                        theme.successThemeAsset,
                      ).image,
                    ),
                    ),
                  ),
                  burnColor: theme.successBurnColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppFlutterLogo(
                        height: 18,
                        isColored: false,
                      ),
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      SizedBox(
                        key: const Key('cinematic_score_completed'),
                        width: completedTextWidth,
                        child: AnimatedDefaultTextStyle(
                          style: PuzzleTextStyle.headline5.copyWith(
                            color: theme.defaultColor,
                          ),
                          duration: PuzzleThemeAnimationDuration.textStyle,
                          child: Text(l10n.dashatarSuccessCompleted),
                        ),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 16,
                        large: 16,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('cinematic_score_well_done'),
                        style: wellDoneTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: Text(l10n.dashatarSuccessWellDone),
                      ),
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('cinematic_score_score'),
                        style: PuzzleTextStyle.headline5.copyWith(
                          color: theme.defaultColor,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: Text(l10n.dashatarSuccessScore),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 9,
                        large: 9,
                      ),
                      CinematicTimer(
                        textStyle: timerTextStyle,
                        iconSize: timerIconSize,
                        iconPadding: timerIconPadding,
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      const ResponsiveGap(
                        small: 2,
                        medium: 8,
                        large: 8,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('cinematic_score_number_of_moves'),
                        style: numberOfMovesTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: Text(
                          l10n.dashatarSuccessNumberOfMoves(
                            state.numberOfMoves.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Create a blurry background for the winning screen
class BlurredSuccessBackground extends StatelessWidget {
  const BlurredSuccessBackground({
    Key? key,
    this.sigma = 5.0,
    this.opacity = 0.25,
    this.topOffset = 220,
    this.bottomOffset  = 110,
    this.burnColor,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final double sigma;
  final double opacity;

  final double topOffset;
  final double bottomOffset;

  final Color? burnColor;

  @override
  Widget build(BuildContext context) {
    Widget colored;
    if (burnColor != null) {
      colored = ColorFiltered(
               colorFilter: ColorFilter.mode(burnColor!, BlendMode.colorBurn),
                child: child,
            );
    } else {
      colored = child;
    }

    return Stack(
      children: [
        child,
        ClipPath(
          clipBehavior: Clip.antiAlias,
          clipper: BlurredSuccessClipper(topOffset: topOffset, bottomOffset: bottomOffset),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: colored,
          ),
        ),

      ],
    );
  }
}

class BlurredSuccessClipper extends CustomClipper<Path> {
  const BlurredSuccessClipper(
      {required this.topOffset, required this.bottomOffset})
      : super();

  final double topOffset;
  final double bottomOffset;

  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(topOffset, 0)
      ..lineTo(bottomOffset, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(BlurredSuccessClipper oldClipper) => true;
}
