// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

// Project imports:
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/settings/settings.dart';
import 'package:cineslide/theme/theme.dart';

/// {@template settings_page}
/// Displays the content for the [SettingsPage].
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const SettingsPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    TextStyle? textStyle;
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
          leading: const Text(''), // Force a blank
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).pop(),
            child: const Icon(
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
                _ExtractMovesTile(activeColor: theme.buttonColor,),
                const Padding(
                  padding: EdgeInsets.only(left: 16,),
                  child: Divider(),
                ),
                _ShowNumbersTile(activeColor: theme.buttonColor,),
                //_ShowHintTile(activeColor: theme.buttonColor,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExtractMovesTile extends StatelessWidget {
  const _ExtractMovesTile({Key? key, this.activeColor}) : super(key: key);

  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(context.l10n.settingsConfirmMoves),
      trailing: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return PlatformSwitch(
            onChanged: (bool nextValue) => context
                .read<SettingsBloc>()
                .add(ConfirmMovesChanged(confirmMoves: nextValue)),
            value: state.confirmMoves,
            material: (_, __) => MaterialSwitchData(
              activeColor: activeColor,
            ),
          );
        },
      ),
    );
  }
}

class _ShowNumbersTile extends StatelessWidget {
  const _ShowNumbersTile({Key? key, this.activeColor}) : super(key: key);

  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(context.l10n.settingsShowTileNumbers),
      trailing: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return PlatformSwitch(
            onChanged: (bool nextValue) => context
                .read<SettingsBloc>()
                .add(ShowTileNumbersChanged(showNumbers: nextValue)),
            value: state.showTileNumbers,
            material: (_, __) => MaterialSwitchData(
              activeColor: activeColor,
            ),
          );
        },
      ),
    );
  }
}

class _ShowHintTile extends StatelessWidget {
  const _ShowHintTile({Key? key, this.activeColor}) : super(key: key);

  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(context.l10n.settingsShowHints),
      trailing: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return PlatformSwitch(
            onChanged: (bool nextValue) => context
                .read<SettingsBloc>()
                .add(ShowHintsChanged(showHints: nextValue)),
            value: state.showHints,
            material: (_, __) => MaterialSwitchData(
              activeColor: activeColor,
            ),
          );
        },
      ),
    );
  }
}
