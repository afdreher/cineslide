// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:cineslide/models/models.dart';

part 'cinematic_puzzle_event.dart';
part 'cinematic_puzzle_state.dart';

/// {@template Cinematic_puzzle_bloc}
/// A bloc responsible for starting the Cinematic puzzle.
/// {@endtemplate}
class CinematicPuzzleBloc
    extends Bloc<CinematicPuzzleEvent, CinematicPuzzleState> {
  /// {@macro Cinematic_puzzle_bloc}
  CinematicPuzzleBloc({
    required this.secondsToBegin,
    required Ticker ticker,
  })  : _ticker = ticker,
        super(CinematicPuzzleState(secondsToBegin: secondsToBegin)) {
    on<CinematicCountdownStarted>(_onCountdownStarted);
    on<CinematicCountdownTicked>(_onCountdownTicked);
    on<CinematicCountdownStopped>(_onCountdownStopped);
    on<CinematicCountdownReset>(_onCountdownReset);
  }

  /// The number of seconds before the puzzle is started.
  final int secondsToBegin;

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick().listen((_) => add(const CinematicCountdownTicked()));
  }

  void _onCountdownStarted(
    CinematicCountdownStarted event,
    Emitter<CinematicPuzzleState> emit,
  ) {
    _startTicker();
    emit(
      state.copyWith(
        isCountdownRunning: true,
        secondsToBegin: secondsToBegin,
      ),
    );
  }

  void _onCountdownTicked(
    CinematicCountdownTicked event,
    Emitter<CinematicPuzzleState> emit,
  ) {
    if (state.secondsToBegin == 0) {
      _tickerSubscription?.pause();
      emit(state.copyWith(isCountdownRunning: false));
    } else {
      emit(state.copyWith(secondsToBegin: state.secondsToBegin - 1));
    }
  }

  void _onCountdownStopped(
    CinematicCountdownStopped event,
    Emitter<CinematicPuzzleState> emit,
  ) {
    _tickerSubscription?.pause();
    emit(
      state.copyWith(
        isCountdownRunning: false,
        secondsToBegin: secondsToBegin,
      ),
    );
  }

  void _onCountdownReset(
    CinematicCountdownReset event,
    Emitter<CinematicPuzzleState> emit,
  ) {
    _startTicker();
    emit(
      state.copyWith(
        isCountdownRunning: true,
        secondsToBegin: event.secondsToBegin ?? secondsToBegin,
      ),
    );
  }
}
