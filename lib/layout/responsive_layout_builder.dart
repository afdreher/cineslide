// Flutter imports:
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:cineslide/layout/layout.dart';

/// Represents the layout size passed to [ResponsiveLayoutBuilder.child].
enum ResponsiveLayoutSize {
  /// Small layout
  small,

  /// Medium layout
  medium,

  /// Large layout
  large
}

/// Signature for the individual builders (`small`, `medium`, `large`).
typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Constraints, Widget?);

/// {@template responsive_layout_builder}
/// A wrapper around [LayoutBuilder] which exposes builders for
/// various responsive breakpoints.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// {@macro responsive_layout_builder}
  const ResponsiveLayoutBuilder({
    Key? key,
    required this.small,
    required this.medium,
    required this.large,
    this.child,
  }) : super(key: key);

  /// [ResponsiveLayoutWidgetBuilder] for small layout.
  final ResponsiveLayoutWidgetBuilder small;

  /// [ResponsiveLayoutWidgetBuilder] for medium layout.
  final ResponsiveLayoutWidgetBuilder medium;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder large;

  /// Optional child widget builder based on the current layout size
  /// which will be passed to the `small`, `medium` and `large` builders
  /// as a way to share/optimize shared layout.
  final Widget Function(ResponsiveLayoutSize currentSize)? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        if (screenWidth <= PuzzleBreakpoints.small) {
          return small(context, constraints, child?.call(ResponsiveLayoutSize.small));
        }
        if (screenWidth <= PuzzleBreakpoints.medium) {
          return medium(context, constraints, child?.call(ResponsiveLayoutSize.medium));
        }
        if (screenWidth <= PuzzleBreakpoints.large) {
          return large(context, constraints, child?.call(ResponsiveLayoutSize.large));
        }

        return large(context, constraints, child?.call(ResponsiveLayoutSize.large));
      },
    );
  }
}
