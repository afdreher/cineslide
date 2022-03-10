// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:cineslide/dashatar/dashatar.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/theme.dart';

/// {@template dashatar_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
class DashatarStartSection extends StatelessWidget {
  /// {@macro dashatar_start_section}
  const DashatarStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((DashatarPuzzleBloc bloc) => bloc.state.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        PuzzleName(
          key: puzzleNameKey,
        ),
        const ResponsiveGap(large: 16),
        PuzzleTitle(
          key: puzzleTitleKey,
          title: context.l10n.puzzleChallengeTitle,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        NumberOfMovesAndTilesLeft(
          key: numberOfMovesAndTilesLeftKey,
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: status == DashatarPuzzleStatus.started
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
          large: (_, __, ___) => const DashatarPuzzleActionButton(),
        ),
        ResponsiveLayoutBuilder(
          small: (_, __, ___) => const DashatarTimer(),
          medium: (_, __, ___) => const DashatarTimer(),
          large: (_, __, ___) => const SizedBox(),
        ),
        const ResponsiveGap(small: 12),
      ],
    );
  }
}
