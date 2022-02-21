// ignore_for_file: public_member_api_docs

part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

/// The currently selected theme has changed.
class ConfirmMovesChanged extends SettingsEvent {
  const ConfirmMovesChanged({required this.confirmMoves});

  /// Whether or not the next state should require confirmation
  final bool confirmMoves;

  @override
  List<Object> get props => [confirmMoves];
}