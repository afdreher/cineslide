// ignore_for_file: public_member_api_docs

part of 'cinematic_puzzle_bloc.dart';

/// The status of [CinematicPuzzleState].
enum CinematicPuzzleStatus {
  /// The puzzle is not started yet.
  notStarted,

  /// The puzzle is loading.
  loading,

  /// The puzzle is started.
  started
}

class CinematicPuzzleState extends Equatable {
  const CinematicPuzzleState({
    required this.secondsToBegin,
    this.isCountdownRunning = false,
    this.animation,
  });

  /// Whether the countdown of this puzzle is currently running.
  final bool isCountdownRunning;

  /// The number of seconds before the puzzle is started.
  final int secondsToBegin;

  final Animation<double>? animation;

  /// The status of the current puzzle.
  CinematicPuzzleStatus get status => isCountdownRunning && secondsToBegin > 0
      ? CinematicPuzzleStatus.loading
      : (secondsToBegin == 0
          ? CinematicPuzzleStatus.started
          : CinematicPuzzleStatus.notStarted);

  @override
  List<Object> get props => [isCountdownRunning, secondsToBegin];

  CinematicPuzzleState copyWith({
    bool? isCountdownRunning,
    int? secondsToBegin,
    Animation<double>? animation,
  }) {
    return CinematicPuzzleState(
      isCountdownRunning: isCountdownRunning ?? this.isCountdownRunning,
      secondsToBegin: secondsToBegin ?? this.secondsToBegin,
      animation: animation ?? this.animation,
    );
  }
}
