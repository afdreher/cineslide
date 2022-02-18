// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cineslide/models/models.dart';

void main() {
  group('inverse', () {
    test('test north', () {
      expect(SlideDirection.north.inverse(), equals(SlideDirection.south));
    });
    test('test south', () {
      expect(SlideDirection.south.inverse(), equals(SlideDirection.north));
    });
    test('test east', () {
      expect(SlideDirection.east.inverse(), equals(SlideDirection.west));
    });
    test('test west', () {
      expect(SlideDirection.west.inverse(), equals(SlideDirection.east));
    });
  });

  group('position', () {
    const startPosition = Position(x: 3, y: 4);

    test('test north', () {
      expect(startPosition.directionTo(const Position(x: 3, y: 1)), equals(SlideDirection.north));
    });
    test('test south', () {
      expect(startPosition.directionTo(const Position(x: 3, y: 6)), equals(SlideDirection.south));
    });
    test('test east', () {
      expect(startPosition.directionTo(const Position(x: 4, y: 4)), equals(SlideDirection.east));
    });
    test('test west', () {
      expect(startPosition.directionTo(const Position(x: 1, y: 4)), equals(SlideDirection.west));
    });
    test('test diagonal', () {
      expect(startPosition.directionTo(const Position(x: 1, y: 1)), isNull);
    });
    test('test no movement', () {
      expect(startPosition.directionTo(const Position(x: 3, y: 4)), isNull);
    });
  });


}
