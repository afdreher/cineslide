// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/l10n/l10n.dart';

/// {@template blue_cinematic_theme}
/// The blue cinematic puzzle theme.
/// {@endtemplate}
class ElliottPancakesTheme extends CinematicTheme {
  /// {@macro blue_cinematic_theme}
  const ElliottPancakesTheme() : super();

    static const String assetName = 'assets/scenes/elliott_pancakes.gif';

  @override
  String get name => 'ElliottPancakes';

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.muybridgeBuffaloThemeLabelText;

  @override
  Color get backgroundColor => PuzzleColors.redPrimary;

  @override
  String? get attribution => 'Taryn Elliott';

  @override
  String? get url => 'https://www.pexels.com/video/pancakes-with-powder-sugar-4177431/';

  @override
  String? get backgroundAsset => assetName;

  @override
  bool get blurBackground => true;

  @override
  Color get defaultColor => PuzzleColors.red50;

  @override
  Color get buttonColor => PuzzleColors.red50;

  @override
  Color get menuInactiveColor => PuzzleColors.red50;

  @override
  Color get countdownColor => PuzzleColors.red50;

  @override
  String get themeAsset => assetName;

  @override
  String get successThemeAsset => assetName;

  @override
  Color? get successBurnColor => PuzzleColors.red50;

  @override
  String get audioControlOffAsset => 'assets/images/audio_control/white_off.png';

  @override
  String get audioAsset => 'assets/audio/dumbbell.mp3';
}
