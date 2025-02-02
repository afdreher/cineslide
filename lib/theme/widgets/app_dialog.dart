// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/colors/colors.dart';
import 'package:cineslide/layout/layout.dart';

/// {@template app_dialog}
/// Displays a full screen dialog on a small display and
/// a fixed-width rounded dialog on a medium and large display.
/// {@endtemplate}
class AppDialog extends StatelessWidget {
  /// {@macro app_dialog}
  const AppDialog({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The content of this dialog.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __, ___) => Material(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: child,
        ),
      ),
      medium: (_, __, child) => child!,
      large: (_, __, child) => child!,
      child: (currentSize) {
        final dialogWidth =
            currentSize == ResponsiveLayoutSize.large ? 740.0 : 700.0;

        return Dialog(
          clipBehavior: Clip.hardEdge,
          backgroundColor: PuzzleColors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: SizedBox(
            width: dialogWidth,
            child: child,
          ),
        );
      },
    );
  }
}
