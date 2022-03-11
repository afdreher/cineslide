// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/settings/settings.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/timer/timer.dart';
import 'package:cineslide/typography/typography.dart';

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