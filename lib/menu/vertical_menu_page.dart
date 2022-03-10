// Flutter imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

// Project imports:
import 'package:cineslide/film/film.dart';
import 'package:cineslide/menu/menu.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/typography/typography.dart';

//TODO: Wrap this in responsive to make it work on Chrome, iPad, etc. but that
// can be a later thing.
class VerticalMenuPage extends StatelessWidget {
  const VerticalMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String buffalo = 'assets/scenes/muybridge_buffalo.gif';
    const String blue = 'assets/images/dashatar/gallery/blue.png';
    const String yellow = 'assets/images/dashatar/gallery/yellow.png';
    const String green = 'assets/images/dashatar/gallery/green.png';

    return PlatformScaffold(
      body: SingleChildScrollView(
          child: FilmStrip.vertical(
        startingNumber: 22,
        aspect: 1.0,
        frameText: (_) => 'FLUTTER DEVPOST',
        children: [
          SafeArea(
            child: Center(
              child: OutlinedText(
                'Cineslide',
                strokeColor: const Color.fromRGBO(88, 82, 75, 1.0),
                strokeWidth: 2.0,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: const Color.fromRGBO(243, 233, 213, 1.0),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          ImageButton.gif(
            asset: buffalo,
            onPressed: () {
              Navigator.of(context).pushNamed(
                'puzzle',
                arguments: PuzzleArguments(
                    theme: const MuybridgeBuffaloTheme(),
                    squareCount: 4),
              );
            },
          ),
          ImageButton.asset(
            asset: blue,
            onPressed: () {},
          ),
          ImageButton.asset(
            asset: yellow,
            onPressed: () {},
          ),
          ImageButton.asset(
            asset: green,
            onPressed: () {},
          ),
        ],
      )),
    );
  }
}
