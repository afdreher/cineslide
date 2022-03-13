// ignore_for_file: public_member_api_docs

part of 'cinematic_puzzle_bloc.dart';

abstract class CinematicPuzzleEvent extends Equatable {
  const CinematicPuzzleEvent();

  @override
  List<Object?> get props => [];
}

class CinematicCountdownStarted extends CinematicPuzzleEvent {
  const CinematicCountdownStarted();
}

class CinematicCountdownTicked extends CinematicPuzzleEvent {
  const CinematicCountdownTicked();
}

class CinematicCountdownStopped extends CinematicPuzzleEvent {
  const CinematicCountdownStopped();
}

class CinematicCountdownReset extends CinematicPuzzleEvent {
  const CinematicCountdownReset({this.secondsToBegin});

  /// The number of seconds to countdown from.
  /// Defaults to [CinematicPuzzleBloc.secondsToBegin] if null.
  final int? secondsToBegin;

  @override
  List<Object?> get props => [secondsToBegin];
}
