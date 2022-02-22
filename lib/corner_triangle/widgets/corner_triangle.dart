import 'package:flutter/material.dart';

import 'package:cineslide/corner_triangle/widgets/corner_triangle_clipper.dart';
import 'package:cineslide/corner_triangle/widgets/corner_triangle_painter.dart';
import 'package:cineslide/corner_triangle/widgets/enums.dart';


class CornerTriangle extends StatelessWidget {
  CornerTriangle({
    Key? key,
    required this.corner,
    this.color,
    this.border,
    this.shadows,
    this.clipBehavior = Clip.none,
    this.child,
  }) : clipper = CornerTriangleClipper(
          corner: corner), super(key: key);

  /// The corner in which to draw the triangle
  final Corner corner;

  final Color? color;
  final BorderSide? border;
  final List<BoxShadow>? shadows;

  final Clip clipBehavior;
 final CornerTriangleClipper clipper;

  final Widget? child;

 @override
  Widget build(BuildContext context) {
   Widget? clippedChild;
   if (child != null && clipBehavior != Clip.none) {
     clippedChild = ClipPath(
       clipper: clipper,
       clipBehavior: clipBehavior,
       child: child,
     );
   } else {
     clippedChild = child;
   }

    return CustomPaint(
      painter: CornerTrianglePainter(
        corner: corner,
        color: color,
        border: border,
        shadows: shadows,
      ),
      child: clippedChild,
    );
  }
}
