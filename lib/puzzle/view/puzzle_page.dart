import 'dart:math' as math;

// Flutter imports:
import 'package:cineslide/tile_image_provider/tile_image_provider.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/film/film.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/settings/settings.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/timer/timer.dart';

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  Future<TileImageProvider?> _generateTiles(
      int count, CinematicTheme theme) async {
    return TileImageProvider.fromImage(
                provider: AssetImage(theme.themeAsset),
                rowCount: count,
                framesPerSecond: theme.fps)
            .then((provider) => provider.generateAllTiles());
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final PuzzleArguments args =
        ModalRoute.of(context)!.settings.arguments as PuzzleArguments;
    final CinematicTheme theme = args.theme;
    final int count = args.squareCount;

    // Find out which theme we need
    context.read<ThemeBloc>().add(ThemeSelected(name: args.theme.name));

    return FutureBuilder<TileImageProvider?>(
      future: _generateTiles(count, theme),
      builder:
          (BuildContext context, AsyncSnapshot<TileImageProvider?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Provider<TileImageProvider>(
            create: (_) => snapshot.data as TileImageProvider,
            child: PuzzleScreen(squareCount: count,),
          );
        }
        return LoadingScreen(theme: theme,);
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key, this.theme}) : super(key: key);

  final CinematicTheme? theme;

  @override
  Widget build(BuildContext context) {
    print('Building loading page');
    return Scaffold(
      body: Center(
        child: Text('Loading Game', style: TextStyle(color: theme?.buttonColor ?? Colors.black),),
      ),
      backgroundColor: theme?.backgroundColor ?? Colors.white,
    );
  }
}

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({Key? key, this.squareCount = 4}) : super(key: key);

  final int squareCount;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CinematicPuzzleBloc(
            secondsToBegin: 3,
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (_) => TimerBloc(
            ticker: const Ticker(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            PuzzleBloc(squareCount, settings: context.read<SettingsBloc>())
              ..add(
                const PuzzleInitialized(
                  /// Shuffle only if the current theme is Simple.
                  shufflePuzzle:
                      false, // context.read<ThemeBloc>().state.theme is SimpleTheme,
                ),
              ),
        child: const PuzzleView(),
      ),
    );
  }
}

/// {@template puzzle_header}
/// Displays the header of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleHeader extends StatelessWidget {
  /// {@macro puzzle_header}
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return SafeArea(
      child: ResponsiveLayoutBuilder(
        // I'm not sure I like the film strip, but I'll keep it for now
        small: (context, constraints, child) => SizedBox(
          height: 200,
          child: Transform.rotate(
            angle: math.pi / 80,
            child: OverflowBox(
              maxWidth: constraints.maxWidth * 1.2,
              child: FilmStrip.horizontal(
                aspect: 0.7,
                startingNumber: 2,
                frameText: (int frame) => frame % 2 == 0
                    ? context.l10n.applicationName.toUpperCase()
                    : '',
                perfCount: 5,
                perfHeight: 15,
                fontSize: 8,
                children: [
                  Center(
                    child: BackButton(
                      color: theme.titleColor,
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const PuzzleLogo(),
                        Divider(
                          indent: 16,
                          endIndent: 16,
                          color: theme.titleColor,
                        ),
                        Text(
                          context.l10n.puzzleChallengeTitle,
                          style: TextStyle(
                            color: theme.titleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: SettingsControl(key: settingsControlKey),
                  ),
                ],
              ),
            ),
          ),
        ),
        medium: (context, __, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              PuzzleLogo(),
              PuzzleMenu(),
            ],
          ),
        ),
        large: (context, __, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              PuzzleLogo(),
              PuzzleMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

/// {@template puzzle_logo}
/// Displays the logo of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleLogo extends StatelessWidget {
  /// {@macro puzzle_logo}
  const PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return AppFlutterLogo(
      key: puzzleLogoKey,
      isColored: theme.isLogoColored,
    );
  }
}

/// {@template puzzle_sections}
/// Displays start and end sections of the puzzle.
/// {@endtemplate}
class PuzzleSections extends StatelessWidget {
  /// {@macro puzzle_sections}
  const PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    final TileImageProvider tileImageProvider =
        Provider.of<TileImageProvider>(context);

    final board = PuzzleBoard(tileImageProvider: tileImageProvider);

    return ResponsiveLayoutBuilder(
      small: (context, __, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(context, state),
          const PuzzleMenu(),
          board,
          theme.layoutDelegate.endSectionBuilder(context, state),
        ],
      ),
      medium: (context, __, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(context, state),
          board,
          theme.layoutDelegate.endSectionBuilder(context, state),
        ],
      ),
      large: (context, __, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(context, state),
          ),
          board,
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(context, state),
          ),
        ],
      ),
    );
  }
}

/// The global key of [PuzzleLogo].
///
/// Used to animate the transition of [PuzzleLogo] when changing a theme.
final puzzleLogoKey = GlobalKey(debugLabel: 'puzzle_logo');

/// The global key of [PuzzleName].
///
/// Used to animate the transition of [PuzzleName] when changing a theme.
final puzzleNameKey = GlobalKey(debugLabel: 'puzzle_name');

/// The global key of [PuzzleTitle].
///
/// Used to animate the transition of [PuzzleTitle] when changing a theme.
final puzzleTitleKey = GlobalKey(debugLabel: 'puzzle_title');

/// The global key of [NumberOfMovesAndTilesLeft].
///
/// Used to animate the transition of [NumberOfMovesAndTilesLeft]
/// when changing a theme.
final numberOfMovesAndTilesLeftKey =
    GlobalKey(debugLabel: 'number_of_moves_and_tiles_left');

/// The global key of [AudioControl].
///
/// Used to animate the transition of [AudioControl]
/// when changing a theme.
final audioControlKey = GlobalKey(debugLabel: 'audio_control');

/// The global key of [SettingsControl].
///
/// Used to animate the transition of [SettingsControl]
/// when changing a theme.
final settingsControlKey = GlobalKey(debugLabel: 'settings_control');
