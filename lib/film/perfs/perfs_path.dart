// Flutter imports:
import 'package:flutter/material.dart';

import 'package:cineslide/film/film.dart';

@immutable
class PerfsPath {
  const PerfsPath(
      {required this.size,
      required this.count,
      required this.ratio,
      required this.radius,
      required this.direction})
      : super();

  final Size size;

  final int count;
  final double ratio;
  final Radius radius;

  final FilmDirection direction;

  Path draw() {
    double limit =
        direction == FilmDirection.vertical ? size.height : size.width;
    double perCell = (limit / count) * ratio;

    double cellWidth =
        direction == FilmDirection.vertical ? size.width : perCell;
    double cellHeight =
        direction == FilmDirection.vertical ? perCell : size.height;

    double remaining = direction == FilmDirection.vertical
        ? size.height - count * cellHeight
        : size.width - count * cellWidth;
    double space = remaining / count;

    // | .5 [] 1 [] 1 [] .5 |
    // | - [] -- [] -- [] - |

    Path path = Path();

    double start = space * 0.5;

    for (int i = 0; i < count; i++) {
      if (direction == FilmDirection.vertical) {
        path.addRRect(
            RRect.fromLTRBR(0, start, size.width, start + cellHeight, radius));
        start += (cellHeight + space);
      } else {
        path.addRRect(
            RRect.fromLTRBR(start, 0, start + cellWidth, size.height, radius));
        start += (cellWidth + space);
      }
    }
    path.close();
    return path;
  }
}
