import 'dart:math';

import 'package:flutter/material.dart';

import 'package:cineslide/corner_triangle/widgets/corner_triangle_path.dart';
import 'package:cineslide/corner_triangle/widgets/enums.dart';

class CornerTrianglePainter extends CustomPainter {
  CornerTrianglePainter({
    required this.corner,
    this.color,
    this.border,
    this.shadows,
  }) : super();

  final Corner corner;

  final Color? color;
  final BorderSide? border;
  final List<BoxShadow>? shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = CornerTrianglePath(
      corner: corner,
      size: size,
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
