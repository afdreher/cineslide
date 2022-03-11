// Flutter imports:
import 'package:cineslide/film/perfs/perfs_path.dart';
import 'package:flutter/material.dart';

import 'package:cineslide/film/film.dart';
import 'package:cineslide/film/frame/measurements.dart';

@immutable
class FramePath {
  const FramePath(
      {required this.size,
      required this.measurements,
      this.pictureInset,
      required this.perfInset,
      required this.perfCount,
      required this.perfPadding,
      required this.perfHeight,
      required this.perfRatio,
      required this.perfRadius,
      required this.direction})
      : super();

  final Size size;
  final Measurements measurements;
  final EdgeInsets? pictureInset;
  final double perfInset;

  final int perfCount;
  final double perfPadding;
  final double perfHeight;
  final double perfRatio;
  final Radius perfRadius;

  final FilmDirection direction;

  Path draw() {
    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final Size perfSize = direction == FilmDirection.vertical
        ? Size(perfHeight, size.height)
        : Size(size.width, perfHeight);

    final Path perfs = PerfsPath(
            size: perfSize,
            count: perfCount,
            ratio: perfRatio,
            radius: perfRadius,
            direction: direction)
        .draw();

    // Add the perfs to the cutout
    if (direction == FilmDirection.vertical) {
      path
        ..addPath(perfs, Offset(perfInset, 0)) // Left
        ..addPath(
            perfs, Offset(size.width - perfInset - perfHeight, 0)); // Right
    } else {
      path
        ..addPath(perfs, Offset(0, perfInset)) // Top
        ..addPath(
            perfs, Offset(0, size.height - perfInset - perfHeight)); // Bottom
    }

    // Do we want to cut out the picture?
    final inset = pictureInset;
    if (inset != null) {
      path.addRect(
          Rect.fromLTRB(inset.left, inset.top, inset.right, inset.bottom));
    }

    path
      ..fillType = PathFillType.evenOdd
      ..close();
    return path;
  }
}
