import 'dart:math' as math;
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/film/film.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/menu/menu.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/typography/typography.dart';
import 'package:cineslide/layout/layout.dart';

//TODO: Wrap this in responsive to make it work on Chrome, iPad, etc. but that
// can be a later thing.
class VerticalMenuPage extends StatelessWidget {
  const VerticalMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _askAmount({required CinematicTheme theme}) async {
      await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: SizedBox(
                width: 200,
                child: FilmStrip.vertical(
                  key: const Key('menu_puzzle_difficulty_selection'),
                  startingNumber: 9,
                  frameText: (int i) {
                    if (i == 9) {
                      return 'DIFFICULTY';
                    }
                    return '';
                  },
                  aspect: 0.7,
                  perfCount: 4,
                  unexposedFilmColor: FilmColors.unexposedColor.withAlpha(220),
                  exposedFilmColor: FilmColors.exposedColor.withAlpha(180),
                  children: <Widget>[
                    _DifficultyButton(
                        difficulty: context.l10n.puzzleDifficultyEasy,
                        squareCount: 3,
                        theme: theme),
                    _DifficultyButton(
                        difficulty: context.l10n.puzzleDifficultyNormal,
                        squareCount: 4,
                        theme: theme),
                    _DifficultyButton(
                        difficulty: context.l10n.puzzleDifficultyHard,
                        squareCount: 5,
                        theme: theme),
                  ],
                ),
              ),
            );
          });
    }

    const buffalo = MuybridgeBuffaloTheme();
    const smoke = ShuraevSmokeTheme();
    const sunset = DetraySunsetTheme();
    const pancakes = ElliottPancakesTheme();

    const titleFrameTextColor = Color.fromRGBO(243, 233, 213, 1.0);

    final menu = FilmStrip.vertical(
      startingNumber: 22,
      aspect: 1.0,
      frameText: (_) => 'FLUTTER DEVPOST',
      children: [
        SafeArea(
          child: TextButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: context.l10n.applicationName,
                applicationVersion: '1.0.0',
              );
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlinedText(
                    context.l10n.applicationName,
                    strokeColor: const Color.fromRGBO(88, 82, 75, 1.0),
                    strokeWidth: 2.0,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: titleFrameTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    color: titleFrameTextColor,
                  ),
                  const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Flutter Puzzle Challenge',
                        style: TextStyle(color: titleFrameTextColor),
                      )),
                ],
              ),
            ),
          ),
        ),
        ImageButton.gif(
          asset: buffalo.themeAsset,
          framesPerSecond: buffalo.fps,
          onPressed: () {
            _askAmount(theme: buffalo);
          },
        ),
        ImageButton.gif(
          asset: smoke.themeAsset,
          framesPerSecond: smoke.fps,
          onPressed: () {
            _askAmount(theme: smoke);
          },
        ),
        ImageButton.gif(
          asset: sunset.themeAsset,
          framesPerSecond: sunset.fps,
          onPressed: () {
            _askAmount(theme: sunset);
          },
        ),
        ImageButton.gif(
          asset: pancakes.themeAsset,
          framesPerSecond: pancakes.fps,
          onPressed: () {
            _askAmount(theme: pancakes);
          },
        ),
      ],
    );

    return PlatformScaffold(
      body: SingleChildScrollView(
        child: ResponsiveLayoutBuilder(
          small: (context, __, child) => menu,
          medium: (context, __, child) => Center(
            child: SizedBox(
              width: PuzzleBreakpoints.small,
              child: menu,
            ),
          ),
          large: (context, __, child) => Center(
            child: SizedBox(
              width: PuzzleBreakpoints.small,
              child: menu,
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    Key? key,
    required this.difficulty,
    required this.squareCount,
    required this.theme,
  }) : super(key: key);

  final String difficulty;
  final int squareCount;
  final CinematicTheme theme;

  @override
  Widget build(BuildContext context) {
    //return LayoutBuilder(builder: (BuildContext context, BoxConstraints constrains) {
    return Center(
        child: Stack(
      children: <Widget>[
        Positioned.fill(
          top: -40,
          child: Align(
            alignment: Alignment.topCenter,
            child: Transform.rotate(
              angle: -math.pi / 10,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Text(
                  squareCount.toString(),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontFamily: 'SourceCodePro',
                    fontSize: 120,
                  ),
                ),
              ),
            ),
            //   strokeColor: const Color(0xFFDDDDDD),
            // ),
          ),
        ),
        Positioned.fill(
          child: TextButton(
            child: OutlinedText(
              difficulty.toUpperCase(),
              style: const TextStyle(
                color: Color(0xBBF0F0F0),
                fontFamily: 'SourceCodePro',
                fontSize: 24,
              ),
              strokeWidth: 1,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/puzzle',
                arguments:
                    PuzzleArguments(theme: theme, squareCount: squareCount),
              );
            },
          ),
        ),
      ],
    ));

    // });
  }
}
