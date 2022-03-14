// Flutter imports:

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
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

  void _launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
}

  @override
  Widget build(BuildContext context) {
    final CinematicTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    Widget? attribution;
    if (theme.attribution != null) {
      Text txt = Text(
        'Photo: ${theme.attribution!}',
        style: TextStyle(color: theme.buttonColor),
      );

      attribution = Align(
        alignment: Alignment.bottomLeft,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: theme.url != null
                ? TextButton(
                    onPressed: () {
                      _launchURL(theme.url);
                    },
                    child: txt,
                  )
                : txt,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
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
            if (attribution != null) attribution,
            // if (theme is! SimpleTheme)
            //  theme.layoutDelegate.backgroundBuilder(state),
          ],
        );
      },
    );
  }
}
