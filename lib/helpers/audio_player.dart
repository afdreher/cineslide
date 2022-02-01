// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:just_audio/just_audio.dart';

/// Signature for the factory of [AudioPlayer].
typedef AudioPlayerFactory = ValueGetter<AudioPlayer>;

/// Gets a new instance of [AudioPlayer].
AudioPlayer getAudioPlayer() => AudioPlayer();

/// Defines extensions for [AudioPlayer].
extension AudioPlayerExtension on AudioPlayer {
  /// Replays the current audio.
  Future<void> replay() async {
    await stop();
    await seek(null);
    unawaited(play());
  }
}
