// ignore_for_file: public_member_api_docs

part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

/// Require moves to be confirmed
class ConfirmMovesChanged extends SettingsEvent {
  const ConfirmMovesChanged({required this.confirmMoves});

  /// Whether or not the next state should require confirmation
  final bool confirmMoves;

  @override
  List<Object> get props => [confirmMoves];
}

/// Show tile number hints
class ShowTileNumbersChanged extends SettingsEvent {
  const ShowTileNumbersChanged({required this.showNumbers});

  /// Whether or not the next state should require confirmation
  final bool showNumbers;

  @override
  List<Object> get props => [showNumbers];
}

/// Show puzzle solution hints
class ShowHintsChanged extends SettingsEvent {
  const ShowHintsChanged({required this.showHints});

  /// Whether or not the next state should require confirmation
  final bool showHints;

  @override
  List<Object> get props => [showHints];
}