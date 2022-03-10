// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/corner_triangle/widgets/corner_triangle_path.dart';
import 'package:cineslide/corner_triangle/widgets/enums.dart';

class CornerTriangleClipper extends CustomClipper<Path> {
  const CornerTriangleClipper({required this.corner}) : super();

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
