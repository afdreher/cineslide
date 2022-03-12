// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/theme/theme.dart';

/// {@template cinematic_theme}
/// The cinematic puzzle theme.
/// {@endtemplate}
abstract class CinematicTheme extends PuzzleTheme {
  /// {@macro cinematic_theme}
  const CinematicTheme() : super();

  @override
  String get name => 'Cinematic';

  @override
  String get audioControlOnAsset =>
      'assets/images/audio_control/dashatar_on.png';

  @override
  bool get hasTimer => true;

  @override
  Color get nameColor => PuzzleColors.white;

  @override
  Color get titleColor => PuzzleColors.white;

  @override
  Color get hoverColor => PuzzleColors.black2;

  @override
  Color get pressedColor => PuzzleColors.white2;

  @override
  Color get correctPressedColor => PuzzleColors.lime90;

  @override
  Color get correctColor => PuzzleColors.lime50;

  @override
  bool get isLogoColored => false;

  @override
  Color get menuActiveColor => PuzzleColors.white;

  @override
  Color get menuUnderlineColor => PuzzleColors.white;

  @override
  PuzzleLayoutDelegate get layoutDelegate =>
      const CinematicPuzzleLayoutDelegate();

  /// The semantics label of this theme.
  String semanticsLabel(BuildContext context);

  /// The text color of the countdown timer.
  Color get countdownColor;

  /// The path to the image asset of this theme.
  ///
  /// This asset is shown in the Cinematic theme picker.
  String get themeAsset;

  /// The path to the success image asset of this theme.
  ///
  /// This asset is shown in the success state of the Cinematic puzzle.
  String get successThemeAsset;

  /// Add a color to the blur window
  Color? get successBurnColor => null;

  /// The path to the audio asset of this theme.
  String get audioAsset;

  @override
  List<Object?> get props => [
        name,
        hasTimer,
        nameColor,
        titleColor,
        backgroundColor,
        backgroundAsset,
    blurBackground,
        defaultColor,
        buttonColor,
        hoverColor,
        pressedColor,
        isLogoColored,
        menuActiveColor,
        menuUnderlineColor,
        menuInactiveColor,
        audioControlOnAsset,
        audioControlOffAsset,
        layoutDelegate,
        countdownColor,
        themeAsset,
        successThemeAsset,
        audioAsset,
      ];
}
