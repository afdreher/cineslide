// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import 'package:cineslide/film/film.dart';

typedef StringTransformer = String Function(int number);

/// A [FilmStrip] contains the child elements placed into a strip.  The child
/// elements will be wrapped inside a frame of appropriate size.
///
/// TODO: Add 'cuts' to the end to make it seem more like a real strip
class FilmStrip extends StatelessWidget {
  const FilmStrip({
    Key? key,
    required this.direction,
    this.children,
    double? aspect,
    int? startingNumber,
    Color? exposedFilmColor,
    Color? unexposedFilmColor,
    Color? textColor,
    this.perfCount,
    this.perfHeight,
    this.fontSize,
    this.frameText,
  })  : aspect = aspect ?? 1.0,
        startingNumber = startingNumber ?? 22,
        exposedFilmColor = exposedFilmColor ?? FilmColors.exposedColor,
        unexposedFilmColor = unexposedFilmColor ?? FilmColors.unexposedColor,
        textColor = textColor ?? FilmColors.textColor,
        super(key: key);

  /// Constructor for a horizontal strip.  Really this is syntactic sugar.
  const FilmStrip.horizontal({
    Key? key,
    List<Widget>? children,
    double? aspect,
    int? startingNumber,
    Color? exposedFilmColor,
    Color? unexposedFilmColor,
    Color? textColor,
    int? perfCount,
    double? perfHeight,
    double? fontSize,
    StringTransformer? frameText,
  }) : this(
          key: key,
          children: children,
          direction: FilmDirection.horizontal,
          aspect: aspect,
          startingNumber: startingNumber,
          exposedFilmColor: exposedFilmColor,
          unexposedFilmColor: unexposedFilmColor,
          textColor: textColor,
          perfCount: perfCount,
          perfHeight: perfHeight,
          fontSize: fontSize,
          frameText: frameText,
        );

  /// Constructor for a vertical strip.  Really this is syntactic sugar.
  const FilmStrip.vertical({
    Key? key,
    List<Widget>? children,
    double? aspect,
    int? startingNumber,
    Color? exposedFilmColor,
    Color? unexposedFilmColor,
    Color? textColor,
    int? perfCount,
    double? perfHeight,
    double? fontSize,
    StringTransformer? frameText,
  }) : this(
          key: key,
          children: children,
          direction: FilmDirection.vertical,
          aspect: aspect,
          startingNumber: startingNumber,
          exposedFilmColor: exposedFilmColor,
          unexposedFilmColor: unexposedFilmColor,
          textColor: textColor,
          perfCount: perfCount,
          perfHeight: perfHeight,
          fontSize: fontSize,
          frameText: frameText,
        );

  /// Direction for the film strip. This is either horizontal or vertical
  final FilmDirection direction;

  /// List of children.  These should only be what goes inside the frame
  final List<Widget>? children;

  /// Aspect ratio of the frame
  final double aspect;

  /// Sequence number for the frames (designed to look like 35mm film)
  final int startingNumber;

  /// Color to use for the unexposed part of the frame (the edges, etc.)
  final Color unexposedFilmColor;

  /// Color to use behind the child widget (if it doesn't fill the entire frame)
  final Color exposedFilmColor;

  final Color textColor;

  final int? perfCount;
  final double? perfHeight;

  final double? fontSize;
  final StringTransformer? frameText;

  @override
  Widget build(BuildContext context) {
    // Convert everything to a frame
    final int count = children?.length ?? 0;
    final List<FilmFrame> frames = children?.mapIndexed((index, value) {
          final int number = direction == FilmDirection.horizontal
              ? startingNumber + index
              : startingNumber + count - index - 1;

          return FilmFrame(
            direction: direction,
            child: value,
            aspect: aspect,
            text: frameText != null ? frameText!(number) : '',
            textColor: textColor,
            fontSize: fontSize,
            exposedFilmColor: exposedFilmColor,
            unexposedFilmColor: unexposedFilmColor,
            number: number,
            perfCount: perfCount,
            perfHeight: perfHeight,
          );
        }).toList(growable: false) ??
        [];

    if (direction == FilmDirection.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: frames,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: frames,
      );
    }
  }
}
