// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/theme/theme.dart';

/// {@template settings_control}
/// Displays the settings widget
/// {@endtemplate}
class SettingsControl extends StatelessWidget {
  /// {@macro settings_control}
  const SettingsControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const IconData? icon = Icons.settings;
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final Color color = theme.nameColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/settings'),
        child: AnimatedSwitcher(
          duration: PuzzleThemeAnimationDuration.backgroundColorChange,
          child: ResponsiveLayoutBuilder(
            key: const Key('settings_control_builder'),
            small: (_, __) => Icon(
              icon,
              key: const Key('settings_control_small'),
              size: 24,
              color: color,
            ),
            medium: (_, __) => Icon(
              icon,
              key: const Key('settings_control_medium'),
              size: 33,
              color: color,
            ),
            large: (_, __) => Icon(
              icon,
              key: const Key('settings_control_large'),
              size: 33,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
