// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/l10n/l10n.dart';

/// {@template green_cinematic_theme}
/// The green cinematic puzzle theme.
/// {@endtemplate}
class ShuraevSmokeTheme extends CinematicTheme {
  /// {@macro green_cinematic_theme}
  const ShuraevSmokeTheme() : super();

  static const String assetName = 'assets/scenes/shuraev_smoke.gif';

  @override
  String get name => 'ShuraevSmoke';

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.shuraevSmokeLabelText;

  @override
  String? get attribution => 'Yaroslav Shuraev';

  @override
  String? get url => 'https://www.pexels.com/video/a-smoke-coming-out-from-the-chimney-4434294/';

  @override
  Color get backgroundColor => PuzzleColors.greenPrimary;

  @override
  String? get backgroundAsset => assetName;

  @override
  bool get blurBackground => false;

  @override
  Color get defaultColor => PuzzleColors.green90;

  @override
  Color get buttonColor => PuzzleColors.green50;

  @override
  Color get menuInactiveColor => PuzzleColors.green50;

  @override
  Color get countdownColor => PuzzleColors.green50;

  @override
  String get themeAsset => assetName;

  @override
  String get successThemeAsset => assetName;

  @override
  Color? get successBurnColor => PuzzleColors.green50;

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/white_off.png';

  @override
  String get audioAsset => 'assets/audio/dumbbell.mp3';

  @override
  int get fps => 10;
}
