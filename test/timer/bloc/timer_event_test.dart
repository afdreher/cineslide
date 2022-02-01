// ignore_for_file: prefer_const_constructors

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cineslide/timer/timer.dart';

void main() {
  const elaspsedSeconds = 1;

  group('TimerEvent', () {
    group('TimerStarted', () {
      test('supports value comparisons', () {
        expect(TimerStarted(), equals(TimerStarted()));
      });
    });

    group('TimerTicked', () {
      test('supports value comparisons', () {
        expect(
          TimerTicked(elaspsedSeconds),
          equals(TimerTicked(elaspsedSeconds)),
        );
      });
    });

    group('TimerStopped', () {
      test('supports value comparisons', () {
        expect(
          TimerStopped(),
          equals(TimerStopped()),
        );
      });
    });

    group('TimerReset', () {
      test('supports value comparisons', () {
        expect(TimerReset(), equals(TimerReset()));
      });
    });
  });
}
