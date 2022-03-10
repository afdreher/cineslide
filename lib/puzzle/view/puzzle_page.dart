// Flutter imports:
import 'package:cineslide/tile_image_provider/tile_image_provider.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/dashatar/dashatar.dart';
import 'package:cineslide/film/film.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/settings/settings.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/timer/timer.dart';
import 'package:cineslide/typography/typography.dart';

// const Map<String, int> boardSizes = {
//   'small': 312,
//   'medium': 424,
//   'large': 472,
// };

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final PuzzleArguments args =
        ModalRoute.of(context)!.settings.arguments as PuzzleArguments;
    final PuzzleTheme theme = args.theme;
    final int count = args.squareCount;

    // Find out which theme we need
    context.read<ThemeBloc>().add(ThemeUpdated(theme: args.theme));

    if (theme is CinematicTheme) {
      return FutureBuilder<TileImageProvider?>(
        future: TileImageProvider.fromImage(
                provider: AssetImage(theme.themeAsset), rowCount: count)
            .then((provider) => provider.generateAllTiles()),
        builder:
            (BuildContext context, AsyncSnapshot<TileImageProvider?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Provider<TileImageProvider>(
              create: (_) => snapshot.data as TileImageProvider,
              child: const PuzzleScreen(),
            );
          }
          return const LoadingScreen();
        },
      );
    } else {
      return const PuzzleScreen();
    }
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
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
          create: (_) => DashatarPuzzleBloc(
            secondsToBegin: 3,
            ticker: const Ticker(),
          ),
        ),
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
        BlocProvider(
          create: (_) => AudioControlBloc(),
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
    // return SizedBox(
    //   height: 96,
    //   child: ResponsiveLayoutBuilder(
    //     small: (context, child) => Stack(
    //       children: [
    //         const Align(
    //           child: PuzzleLogo(),
    //         ),
    //         Align(
    //           alignment: Alignment.centerRight,
    //           child: Padding(
    //             padding: const EdgeInsets.only(right: 34),
    //             child: AudioControl(key: audioControlKey),
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.centerLeft,
    //           child: Padding(
    //             padding: const EdgeInsets.only(left: 34),
    //             child: SettingsControl(key: settingsControlKey),
    //           ),
    //         ),
    //       ],
    //     ),
    //     medium: (context, child) => Padding(
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 50,
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: const [
    //           PuzzleLogo(),
    //           PuzzleMenu(),
    //         ],
    //       ),
    //     ),
    //     large: (context, child) => Padding(
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 50,
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: const [
    //           PuzzleLogo(),
    //           PuzzleMenu(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return SafeArea(
      child: SizedBox(
        height: 200,
        child: ResponsiveLayoutBuilder(
          small: (context, constraints, child) => FilmStrip.horizontal(
            aspect: 0.667,
            startingNumber: 2,
            frameText: (int frame) => frame % 2 == 0 ? 'CINESLIDE' : '',
            perfCount: 5,
            perfHeight: 15,
            fontSize: 8,
            children: [
              Center(
                child: SettingsControl(key: settingsControlKey),
              ),
              const Center(
                child: PuzzleLogo(),
              ),
              Center(
                child: AudioControl(key: audioControlKey),
              ),
            ],
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

    return ResponsiveLayoutBuilder(
      small: (context, __, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(context, state),
          const PuzzleMenu(),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(context, state),
        ],
      ),
      medium: (context, __, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(context, state),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(context, state),
        ],
      ),
      large: (context, __, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(context, state),
          ),
          const PuzzleBoard(),
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(context, state),
          ),
        ],
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return PuzzleKeyboardHandler(
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
            context.read<TimerBloc>().add(const TimerStopped());
          }
        },
        child: theme.layoutDelegate.boardBuilder(
          context,
          size,
          puzzle.tiles
              .map(
                (tile) => _PuzzleTile(
                  key: Key('puzzle_tile_${tile.value.toString()}'),
                  tile: tile,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate
            .whitespaceTileBuilder(context, tile: tile, state: state)
        : theme.layoutDelegate.tileBuilder(context, tile, state);
  }
}

/// {@template puzzle_menu}
/// Displays the menu of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleMenu extends StatelessWidget {
  /// {@macro puzzle_menu}
  const PuzzleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ResponsiveLayoutBuilder(
          small: (_, __, child) => const SizedBox(),
          medium: (_, __, child) => child!,
          large: (_, __, child) => child!,
          child: (currentSize) {
            return Row(
              children: [
                const Gap(44),
                SettingsControl(key: settingsControlKey),
                const Gap(44),
                AudioControl(
                  key: audioControlKey,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

/// {@template puzzle_menu_item}
/// Displays the menu item of the [PuzzleMenu].
/// {@endtemplate}
@visibleForTesting
class PuzzleMenuItem extends StatelessWidget {
  /// {@macro puzzle_menu_item}
  const PuzzleMenuItem({
    Key? key,
    required this.theme,
    required this.themeIndex,
  }) : super(key: key);

  /// The theme corresponding to this menu item.
  final PuzzleTheme theme;

  /// The index of [theme] in [ThemeState.themes].
  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final isCurrentTheme = theme == currentTheme;

    return ResponsiveLayoutBuilder(
      small: (_, __, child) => Column(
        children: [
          Container(
            width: 100,
            height: 40,
            decoration: isCurrentTheme
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: currentTheme.menuUnderlineColor,
                      ),
                    ),
                  )
                : null,
            child: child,
          ),
        ],
      ),
      medium: (_, __, child) => child!,
      large: (_, __, child) => child!,
      child: (currentSize) {
        final leftPadding =
            themeIndex > 0 && currentSize != ResponsiveLayoutSize.small
                ? 40.0
                : 0.0;

        return Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Tooltip(
            message:
                theme != currentTheme ? context.l10n.puzzleChangeTooltip : '',
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                // Ignore if this theme is already selected.
                if (theme == currentTheme) {
                  return;
                }

                // Update the currently selected theme.
                context
                    .read<ThemeBloc>()
                    .add(ThemeChanged(themeIndex: themeIndex));

                // Reset the timer of the currently running puzzle.
                context.read<TimerBloc>().add(const TimerReset());

                // Stop the Dashatar countdown if it has been started.
                // context.read<DashatarPuzzleBloc>().add(
                //       const DashatarCountdownStopped(),
                //     );

                context.read<CinematicPuzzleBloc>().add(
                      const CinematicCountdownStopped(),
                    );

                // Initialize the puzzle board for the newly selected theme.
                // context.read<PuzzleBloc>().add(
                //       PuzzleInitialized(
                //         shufflePuzzle: theme is SimpleTheme,
                //       ),
                //     );
              },
              child: AnimatedDefaultTextStyle(
                duration: PuzzleThemeAnimationDuration.textStyle,
                style: PuzzleTextStyle.headline5.copyWith(
                  color: isCurrentTheme
                      ? currentTheme.menuActiveColor
                      : currentTheme.menuInactiveColor,
                ),
                child: Text(theme.name),
              ),
            ),
          ),
        );
      },
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
