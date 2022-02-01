// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cineslide/layout/layout.dart';

extension PuzzleWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }

  void setLargeDisplaySize() {
    setDisplaySize(const Size(PuzzleBreakpoints.large, 1000));
  }

  void setMediumDisplaySize() {
    setDisplaySize(const Size(PuzzleBreakpoints.medium, 1000));
  }

  void setSmallDisplaySize() {
    setDisplaySize(const Size(PuzzleBreakpoints.small, 1000));
  }
}
