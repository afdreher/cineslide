// ignore_for_file: prefer_const_constructors

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/gap.dart';

// Project imports:
import 'package:cineslide/layout/layout.dart';
import '../helpers/helpers.dart';

void main() {
  group('ResponsiveGap', () {
    const smallGap = 10.0;
    const mediumGap = 20.0;
    const largeGap = 30.0;

    testWidgets('renders a large gap on a large display', (tester) async {
      tester.setLargeDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: ResponsiveGap(
            small: smallGap,
            medium: mediumGap,
            large: largeGap,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Gap && widget.mainAxisExtent == largeGap,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders a medium gap on a medium display', (tester) async {
      tester.setMediumDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: ResponsiveGap(
            small: smallGap,
            medium: mediumGap,
            large: largeGap,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Gap && widget.mainAxisExtent == mediumGap,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders a small gap on a small display', (tester) async {
      tester.setSmallDisplaySize();

      await tester.pumpApp(
        SingleChildScrollView(
          child: ResponsiveGap(
            small: smallGap,
            medium: mediumGap,
            large: largeGap,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Gap && widget.mainAxisExtent == smallGap,
        ),
        findsOneWidget,
      );
    });
  });
}
