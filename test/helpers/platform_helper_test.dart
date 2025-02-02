// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:cineslide/helpers/helpers.dart';

void main() {
  group('getPlatformHelper', () {
    test('returns a new instance of PlatformHelper', () {
      expect(getPlatformHelper(), isA<PlatformHelper>());
    });
  });

  group('PlatformHelper', () {
    test('isWeb returns UniversalPlatform.isWeb', () {
      expect(PlatformHelper().isWeb, equals(UniversalPlatform.isWeb));
    });
  });
}
