// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/timer/timer.dart';

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);

    return Scaffold(
      floatingActionButton: BlocBuilder<PuzzleBloc, PuzzleState>(
        builder: (BuildContext context, PuzzleState state) {
          final bool isVisible = context.read<PuzzleBloc>().state.isPending;
          const duration = Duration(milliseconds: 150);
          return AnimatedSlide(
            duration: duration,
            offset: isVisible ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: duration,
              opacity: isVisible ? 1 : 0.25,
              child: FloatingActionButton(
                backgroundColor: theme.buttonColor,
                tooltip: context.l10n.puzzleCommit,
                child: const Icon(Icons.check, color: PuzzleColors.white),
                onPressed: () =>
                    context.read<PuzzleBloc>().add(const TileConfirmed()),
              ),
            ),
          );
        },
      ),
      body: AnimatedContainer(
        duration: PuzzleThemeAnimationDuration.backgroundColorChange,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TimerBloc(
                ticker: const Ticker(),
              ),
            ),
          ],
          child: const _Puzzle(
            key: Key('puzzle_view_puzzle'),
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // if (theme is SimpleTheme)
            theme.layoutDelegate.backgroundBuilder(context, state),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: const [
                    PuzzleHeader(),
                    PuzzleSections(),
                  ],
                ),
              ),
            ),
            // if (theme is! SimpleTheme)
            //  theme.layoutDelegate.backgroundBuilder(state),
          ],
        );
      },
    );
  }
}
