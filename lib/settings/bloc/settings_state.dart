// ignore_for_file: public_member_api_docs

part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.confirmMoves,
    required this.showTileNumbers,
    required this.showHints,
  });

  /// Currently selected theme.
  final bool confirmMoves;
  final bool showTileNumbers;
  final bool showHints;

  @override
  List<Object> get props => [confirmMoves, showTileNumbers, showHints];

  SettingsState copyWith({
    bool? confirmMoves,
    bool? showTileNumbers,
    bool? showHints,
  }) {
    return SettingsState(
      confirmMoves: confirmMoves ?? this.confirmMoves,
      showTileNumbers: showTileNumbers ?? this.showTileNumbers,
      showHints: showHints ?? this.showHints,
    );
  }
}
