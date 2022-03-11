// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/film/film.dart';
import 'package:cineslide/film/frame/frame_path.dart';
import 'package:cineslide/film/frame/measurements.dart';

class FrameClipper extends CustomClipper<Path> {
  const FrameClipper(
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

  @override
  Path getClip(Size size) {
    final FramePath path = FramePath(
      size: size,
      measurements: measurements,
      pictureInset: pictureInset,
      perfInset: perfInset,
      perfCount: perfCount,
      perfPadding: perfPadding,
      perfHeight: perfHeight,
      perfRatio: perfRatio,
      perfRadius: perfRadius,
      direction: direction,
    );
    return path.draw();
  }

  @override
  bool shouldReclip(FrameClipper oldClipper) => true;
}
