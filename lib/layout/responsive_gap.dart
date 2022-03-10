// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:gap/gap.dart';

// Project imports:
import 'package:cineslide/layout/layout.dart';

/// {@template responsive_gap}
/// A wrapper around [Gap] that renders a [small], [medium]
/// or a [large] gap depending on the screen size.
/// {@endtemplate}
class ResponsiveGap extends StatelessWidget {
  /// {@macro responsive_gap}
  const ResponsiveGap({
    Key? key,
    this.small = 0,
    this.medium = 0,
    this.large = 0,
  }) : super(key: key);

  /// A gap rendered on a small layout.
  final double small;

  /// A gap rendered on a medium layout.
  final double medium;

  /// A gap rendered on a large layout.
  final double large;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __, ___) => Gap(small),
      medium: (_, __, ___) => Gap(medium),
      large: (_, __, ___) => Gap(large),
    );
  }
}
