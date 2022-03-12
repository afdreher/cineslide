// ignore_for_file: public_member_api_docs

part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({
    required this.themes,
    this.theme = const MuybridgeBuffaloTheme(),
  });

  /// The list of all available themes.
  final List<CinematicTheme> themes;

  /// Currently selected theme.
  final CinematicTheme theme;

  @override
  List<Object> get props => [themes, theme];

  ThemeState copyWith({
    List<CinematicTheme>? themes,
    CinematicTheme? theme,
  }) {
    return ThemeState(
      themes: themes ?? this.themes,
      theme: theme ?? this.theme,
    );
  }
}
