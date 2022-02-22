import 'package:flutter/material.dart';

import 'package:cineslide/corner_triangle/widgets/enums.dart';
import 'package:cineslide/corner_triangle/widgets/corner_triangle_path.dart';

class CornerTriangleClipper extends CustomClipper<Path> {
  CornerTriangleClipper({required this.corner}) : super();

  @override
  Path getClip(Size size) {
    final CornerTrianglePath path = CornerTrianglePath(
      size: size,
      corner: corner,
    );
    return path.draw();
  }

  final Corner corner;
  @override
  bool shouldReclip(CornerTriangleClipper oldClipper) => false;
}
