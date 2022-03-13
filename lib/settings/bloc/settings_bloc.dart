// ignore_for_file: public_member_api_docs

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(const SettingsState(
          soundOn: true,
          confirmMoves: false,
          showTileNumbers: false,
          showHints: false,
        )) {
    on<SoundOnChanged>(_onSoundOnChanged);
    on<ConfirmMovesChanged>(_onConfirmMovesChanged);
    on<ShowTileNumbersChanged>(_onShowTileNumbersChanged);
    on<ShowHintsChanged>(_onShowHintsChanged);
  }

  void _onSoundOnChanged(SoundOnChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(soundOn: event.soundOn));
  }

  void _onConfirmMovesChanged(
      ConfirmMovesChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(confirmMoves: event.confirmMoves));
  }

  void _onShowTileNumbersChanged(
      ShowTileNumbersChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(showTileNumbers: event.showNumbers));
  }

  void _onShowHintsChanged(
      ShowHintsChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(showHints: event.showHints));
  }
}
