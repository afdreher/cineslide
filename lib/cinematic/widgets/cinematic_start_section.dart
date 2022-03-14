// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/theme.dart';

/// {@template cinematic_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
class CinematicStartSection extends StatelessWidget {
  /// {@macro cinematic_start_section}
  const CinematicStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((CinematicPuzzleBloc bloc) => bloc.state.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const ResponsiveGap(
        //   small: 20,
        //   medium: 83,
        //   large: 151,
        // ),
        // PuzzleName(
        //   key: puzzleNameKey,
        // ),
        // const ResponsiveGap(large: 16),
        // PuzzleTitle(
        //   key: puzzleTitleKey,
        //   title: context.l10n.puzzleChallengeTitle,
        // ),
        // const ResponsiveGap(
        //   small: 4,
        //   medium: 8,
        //   large: 12,
        // ),
        NumberOfMovesAndTilesLeft(
          key: numberOfMovesAndTilesLeftKey,
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: status == CinematicPuzzleStatus.started
              ? state.numberOfTilesLeft
              : state.puzzle.tiles.length - 1,
        ),
        const ResponsiveGap(
          small: 8,
          medium: 18,
          large: 32,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __, ___) => const SizedBox(),
          medium: (_, __, ___) => const SizedBox(),
          large: (_, __, ___) => const CinematicPuzzleActionButton(),
        ),
        ResponsiveLayoutBuilder(
          small: (_, __, ___) => const CinematicTimer(),
          medium: (_, __, ___) => const CinematicTimer(),
          large: (_, __, ___) => const SizedBox(),
        ),
        const ResponsiveGap(small: 12),
      ],
    );
  }
}
