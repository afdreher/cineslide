// ignore_for_file: public_member_api_docs

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState(confirmMoves: false)) {
    on<ConfirmMovesChanged>(_onConfirmMovesChanged);
  }

  void _onConfirmMovesChanged(ConfirmMovesChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(confirmMoves: event.confirmMoves));
  }
}
