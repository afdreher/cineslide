// ignore_for_file: prefer_const_constructors

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';

void main() {
  group('AudioControlEvent', () {
    group('AudioToggled', () {
      test('supports value comparisons', () {
        expect(AudioToggled(), equals(AudioToggled()));
      });
    });
  });
}
