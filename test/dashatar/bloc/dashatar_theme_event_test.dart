// ignore_for_file: prefer_const_constructors

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cineslide/dashatar/dashatar.dart';

void main() {
  group('DashatarThemeEvent', () {
    group('DashatarThemeChanged', () {
      test('supports value comparisons', () {
        expect(
          DashatarThemeChanged(themeIndex: 1),
          equals(DashatarThemeChanged(themeIndex: 1)),
        );
        expect(
          DashatarThemeChanged(themeIndex: 2),
          isNot(DashatarThemeChanged(themeIndex: 1)),
        );
      });
    });
  });
}
