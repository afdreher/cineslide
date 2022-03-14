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
            return SimpleDialog(
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/puzzle',
                      arguments: PuzzleArguments(theme: theme, squareCount: 3),
                    );
                  },
                  child: const Text('Easy: 3'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/puzzle',
                      arguments: PuzzleArguments(theme: theme, squareCount: 4),
                    );
                  },
                  child: const Text('Normal: 4'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/puzzle',
                      arguments: PuzzleArguments(theme: theme, squareCount: 5),
                    );
                  },
                  child: const Text('Hard: 5'),
                ),
              ],
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
