import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
    TextStyle? textStyle = null;
    if (isMaterial(context)) {
      textStyle = TextStyle(color: theme.nameColor);
    }

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: title != null
            ? Text(
                title!,
                style: textStyle,
              )
            : null,
        material: (_, __) => MaterialAppBarData(
          backgroundColor: theme.backgroundColor,
          foregroundColor: theme.titleColor,
          centerTitle: true,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          leading: Text(''), // Force a blank
          trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(
                CupertinoIcons.clear_circled_solid,
                color: Colors.grey,
              ),
          ),
        ),
      ),
      iosContentPadding: true,
      body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: PlatformText(context.l10n.settingsConfirmMoves),
                    trailing: BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return PlatformSwitch(
                          onChanged: (bool nextValue) => context
                              .read<SettingsBloc>()
                              .add(
                                  ConfirmMovesChanged(confirmMoves: nextValue)),
                          value: state.confirmMoves,
                          material: (_, __) => MaterialSwitchData(
                            activeColor: theme.buttonColor,
                          ),
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
