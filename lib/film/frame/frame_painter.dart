// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:cineslide/film/film.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/film/frame/frame_path.dart';
import 'package:cineslide/film/frame/measurements.dart';

class FramePainter extends CustomPainter {
  const FramePainter({
    required this.measurements,
    this.pictureInset,
    required this.perfInset,
    required this.perfCount,
    required this.perfPadding,
    required this.perfHeight,
    required this.perfRatio,
    required this.perfRadius,
    required this.direction,
    this.color,
    this.border,
    this.shadows,
  }) : super();

  final Measurements measurements;
  final EdgeInsets? pictureInset;
  final double perfInset;

  final int perfCount;
  final double perfPadding;
  final double perfHeight;
  final double perfRatio;
  final Radius perfRadius;

  final FilmDirection direction;

  final Color? color;
  final BorderSide? border;
  final List<BoxShadow>? shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = FramePath(
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
    ).draw();

    if (shadows != null) {
      for (BoxShadow s in shadows!) {
        canvas
          ..save()
          ..translate(s.offset.dx, s.offset.dy)
          ..drawShadow(path, s.color, sqrt(s.blurRadius), true)
          ..restore();
      }
    }

    if (color != null) {
      final Paint bgPaint = Paint()..color = color!;
      canvas.drawPath(path, bgPaint);
    }

    if (border != null && border!.style == BorderStyle.solid) {
      // Don't shift the path for drawing the border; clip it instead. I know
      // this isn't as efficient, but it creates a better result

      // Draw outline
      final Paint borderPaint = Paint()
        ..color = border!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * border!.width;
      canvas
        ..save()
        ..clipPath(path)
        ..drawPath(path, borderPaint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
