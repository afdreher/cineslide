import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/settings/settings.dart';

/// {@template settings_page}
/// Displays the content for the [SettingsPage].
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const SettingsPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.backgroundColor,
          foregroundColor: theme.titleColor,
          title: title != null
              ? Text(
                  title!,
                  style: TextStyle(color: theme.nameColor),
                )
              : null,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
              child: Center(
        child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 500,
                ),
                child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(context.l10n.settingsConfirmMoves),
              trailing: BlocBuilder<SettingsBloc, SettingsState>(
  builder: (context, state) {
              return Switch(
                onChanged: (bool nextValue) => context.read<SettingsBloc>().add(
                  ConfirmMovesChanged(confirmMoves: nextValue)
                ),
                value: state.confirmMoves,
                activeTrackColor: theme.buttonColor,
              );
              },
            ),
            ),
          ],
        ),
        ),
    ),
        ),
    );
  }
}
