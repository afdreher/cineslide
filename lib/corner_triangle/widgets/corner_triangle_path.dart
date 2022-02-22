import 'package:flutter/material.dart';

import 'package:cineslide/corner_triangle/widgets/enums.dart';

@immutable
class DoublePoint {
  const DoublePoint(this.x, this.y);

  final double x, y;

  factory DoublePoint.zero() => const DoublePoint(0.0, 0.0);
}

@immutable
class CornerTrianglePath {
  const CornerTrianglePath({required this.size, required this.corner})
      : super();

  final Size size;
  final Corner corner;

  Path draw() {
    final DoublePoint topLeft = DoublePoint.zero();
    final DoublePoint topRight = DoublePoint(size.width, 0);
    final DoublePoint bottomLeft = DoublePoint(0, size.height);
    final DoublePoint bottomRight = DoublePoint(size.width, size.height);

    switch (corner) {
      case Corner.topLeft:
        return _pathFromPoints(topLeft, topRight, bottomLeft);
      case Corner.topRight:
        return _pathFromPoints(topRight, bottomRight, topLeft);
      case Corner.bottomRight:
        return _pathFromPoints(bottomRight, bottomLeft, topRight);
      case Corner.bottomLeft:
        return _pathFromPoints(bottomLeft, topLeft, bottomRight);
    }
  }

  Path _pathFromPoints(
      DoublePoint start, DoublePoint intermediate, DoublePoint end) {
    return Path()
      ..moveTo(start.x, start.y)
      ..lineTo(intermediate.x, intermediate.y)
      ..lineTo(end.x, end.y)
      ..close();
  }
}
