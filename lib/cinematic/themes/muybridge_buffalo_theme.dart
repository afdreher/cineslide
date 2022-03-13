// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/l10n/l10n.dart';

/// {@template blue_cinematic_theme}
/// The blue cinematic puzzle theme.
/// {@endtemplate}
class MuybridgeBuffaloTheme extends CinematicTheme {
  /// {@macro blue_cinematic_theme}
  const MuybridgeBuffaloTheme() : super();

    static const String assetName = 'assets/scenes/muybridge_buffalo.gif';

  @override
  String get name => 'MuybridgeBuffalo';

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.muybridgeBuffaloThemeLabelText;

  @override
  Color get backgroundColor => PuzzleColors.bluePrimary;

  @override
  String? get attribution => 'Eadweard Muybridge, 1887';

  @override
  String? get url => 'https://en.wikipedia.org/wiki/File:Muybridge_Buffalo_galloping.gif';

  @override
  String? get backgroundAsset => assetName;

  @override
  bool get blurBackground => true;

  @override
  Color get defaultColor => PuzzleColors.blue90;

  @override
  Color get buttonColor => PuzzleColors.blue50;

  @override
  Color get menuInactiveColor => PuzzleColors.blue50;

  @override
  Color get countdownColor => PuzzleColors.blue50;

  @override
  String get themeAsset => assetName;

  @override
  String get successThemeAsset => assetName;

  @override
  Color? get successBurnColor => PuzzleColors.blue50;

  @override
  String get audioControlOffAsset => 'assets/images/audio_control/white_off.png';

  @override
  String get audioAsset => 'assets/audio/dumbbell.mp3';
}
