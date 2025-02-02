// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/helpers/helpers.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';

/// {@template puzzle_keyboard_handler}
/// A widget that listens to the keyboard events and moves puzzle tiles
/// whenever a user presses keyboard arrows (←, →, ↑, ↓).
/// {@endtemplate}
class PuzzleKeyboardHandler extends StatefulWidget {
  /// {@macro puzzle_keyboard_handler}
  const PuzzleKeyboardHandler({
    Key? key,
    required this.child,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State createState() => _PuzzleKeyboardHandlerState();
}

class _PuzzleKeyboardHandlerState extends State<PuzzleKeyboardHandler> {
  // The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();

  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/tile_move.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    //final theme = context.read<ThemeBloc>().state.theme;

    // The user may move tiles only when the puzzle is started.
    // There's no need to check the Simple theme as it is started by default.
    final canMoveTiles = context.read<CinematicPuzzleBloc>().state.status ==
            CinematicPuzzleStatus.started;

    if (event is RawKeyDownEvent && canMoveTiles) {
      final puzzle = context.read<PuzzleBloc>().state.puzzle;
      //final preference = context.read<PreferencesBloc>().state;
      final physicalKey = event.data.physicalKey;

      Tile? tile;
      // Make this optional so that you can move either the whitespace or the
      // block.  Also make it so you can confirm, if so desired.  Confirm with
      // pop-up / enter would be useful for lower vision users.
      if (physicalKey == PhysicalKeyboardKey.arrowDown) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(0, 1));
      } else if (physicalKey == PhysicalKeyboardKey.arrowUp) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(0, -1));
      } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(1, 0));
      } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(-1, 0));
      } else if (physicalKey == PhysicalKeyboardKey.enter) {
        // Confirm move
        context.read<PuzzleBloc>().add(const TileConfirmed());
        unawaited(_audioPlayer.replay());
        return;
      }

      if (tile != null) {
        context.read<PuzzleBloc>().add(TileTapped(tile));
        unawaited(_audioPlayer.replay()); // This needs to be moved elsewhere!
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: Builder(
          builder: (context) {
            if (!_focusNode.hasFocus) {
              FocusScope.of(context).requestFocus(_focusNode);
            }
            return widget.child;
          },
        ),
      ),
    );
  }
}
