// ignore_for_file: public_member_api_docs

part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.confirmMoves,
  });

  /// Currently selected theme.
  final bool confirmMoves;

  @override
  List<Object> get props => [confirmMoves];

  SettingsState copyWith({
    bool? confirmMoves,
  }) {
    return SettingsState(
      confirmMoves: confirmMoves ?? this.confirmMoves,
    );
  }
}
