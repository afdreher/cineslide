// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/helpers/helpers.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/timer/timer.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/typography/typography.dart';

/// {@template dashatar_countdown}
/// Displays the countdown before the puzzle is started.
/// {@endtemplate}
class CinematicCountdown extends StatefulWidget {
  /// {@macro dashatar_countdown}
  const CinematicCountdown({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<CinematicCountdown> createState() => _CinematicCountdownState();
}

class _CinematicCountdownState extends State<CinematicCountdown> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/shuffle.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: BlocListener<CinematicPuzzleBloc, CinematicPuzzleState>(
        listener: (context, state) {
          if (!state.isCountdownRunning) {
            return;
          }

          // Play the shuffle sound when the countdown from 3 to 1 begins.
          if (state.secondsToBegin == 3) {
            unawaited(_audioPlayer.replay());
          }

          // Start the puzzle timer when the countdown finishes.
          if (state.status == CinematicPuzzleStatus.started) {
            context.read<TimerBloc>().add(const TimerStarted());
          }

          // Shuffle the puzzle on every countdown tick.
          if (state.secondsToBegin >= 1 && state.secondsToBegin <= 3) {
            context.read<PuzzleBloc>().add(const PuzzleReset());
          }
        },
        child: ResponsiveLayoutBuilder(
          small: (_, __, ___) => const SizedBox(),
          medium: (_, __, ___) => const SizedBox(),
          large: (_, __, ___) =>
              BlocBuilder<CinematicPuzzleBloc, CinematicPuzzleState>(
            builder: (context, state) {
              if (!state.isCountdownRunning || state.secondsToBegin > 3) {
                return const SizedBox();
              }

              if (state.secondsToBegin > 0) {
                return CinematicCountdownSecondsToBegin(
                  key: ValueKey(state.secondsToBegin),
                  secondsToBegin: state.secondsToBegin,
                );
              } else {
                return const CinematicCountdownGo();
              }
            },
          ),
        ),
      ),
    );
  }
}

/// {@template dashatar_countdown_seconds_to_begin}
/// Display how many seconds are left to begin the puzzle.
/// {@endtemplate}
@visibleForTesting
class CinematicCountdownSecondsToBegin extends StatefulWidget {
  /// {@macro dashatar_countdown_seconds_to_begin}
  const CinematicCountdownSecondsToBegin({
    Key? key,
    required this.secondsToBegin,
  }) : super(key: key);

  /// The number of seconds before the puzzle is started.
  final int secondsToBegin;

  @override
  State<CinematicCountdownSecondsToBegin> createState() =>
      _CinematicCountdownSecondsToBeginState();
}

class _CinematicCountdownSecondsToBeginState
    extends State<CinematicCountdownSecondsToBegin>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outOpacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.81, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return FadeTransition(
      opacity: outOpacity,
      child: FadeTransition(
        opacity: inOpacity,
        child: ScaleTransition(
          scale: inScale,
          child: Text(
            widget.secondsToBegin.toString(),
            style: PuzzleTextStyle.countdownTime.copyWith(
              color: theme is CinematicTheme ? theme.countdownColor : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template dashatar_countdown_go}
/// Displays a "Go!" text when the countdown reaches 0 seconds.
/// {@endtemplate}
@visibleForTesting
class CinematicCountdownGo extends StatefulWidget {
  /// {@macro dashatar_countdown_go}
  const CinematicCountdownGo({Key? key}) : super(key: key);

  @override
  State<CinematicCountdownGo> createState() => _CinematicCountdownGoState();
}

class _CinematicCountdownGoState extends State<CinematicCountdownGo>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outScale;
  late Animation<double> outOpacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.37, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.37, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.63, 1, curve: Curves.easeIn),
      ),
    );

    outScale = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.63, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return Padding(
      padding: const EdgeInsets.only(top: 101),
      child: FadeTransition(
        opacity: outOpacity,
        child: FadeTransition(
          opacity: inOpacity,
          child: ScaleTransition(
            scale: outScale,
            child: ScaleTransition(
              scale: inScale,
              child: Text(
                context.l10n.dashatarCountdownGo,
                style: PuzzleTextStyle.countdownTime.copyWith(
                  fontSize: 100,
                  color: theme.defaultColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
