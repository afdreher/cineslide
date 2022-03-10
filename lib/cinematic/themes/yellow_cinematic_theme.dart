// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/l10n/l10n.dart';

/// {@template yellow_cinematic_theme}
/// The yellow cinematic puzzle theme.
/// {@endtemplate}
class YellowCinematicTheme extends CinematicTheme {
  /// {@macro yellow_cinematic_theme}
  const YellowCinematicTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarYellowDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.yellowPrimary;

  @override
  String? get backgroundAsset => null;

  @override
  bool get blurBackground => false;

  @override
  Color get defaultColor => PuzzleColors.yellow90;

  @override
  Color get buttonColor => PuzzleColors.yellow50;

  @override
  Color get menuInactiveColor => PuzzleColors.yellow50;

  @override
  Color get countdownColor => PuzzleColors.yellow50;

  @override
  String get themeAsset => 'assets/images/dashatar/gallery/yellow.png';

  @override
  String get successThemeAsset => 'assets/images/dashatar/success/yellow.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/yellow_dashatar_off.png';

  @override
  String get audioAsset => 'assets/audio/sandwich.mp3';
}
