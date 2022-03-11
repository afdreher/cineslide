// // Flutter imports:
// import 'package:flutter/material.dart';
//
// // Project imports:
// import 'package:cineslide/film/film.dart';
//
// class Perfs extends StatelessWidget {
//   Perfs({
//     Key? key,
//     required this.count,
//     this.ratio = 0.5,
//     this.radius = const Radius.circular(5.0),
//     this.direction = FilmDirection.horizontal,
//     this.color,
//     this.border,
//     this.shadows,
//     this.clipBehavior = Clip.hardEdge,
//     this.child,
//   })  : clipper = PerfsClipper(
//           count: count,
//           ratio: ratio,
//           radius: radius,
//           direction: direction,
//         ),
//         super(key: key);
//
//   final int count;
//   final double ratio;
//   final Radius radius;
//
//   final FilmDirection direction;
//
//   final Color? color;
//   final BorderSide? border;
//   final List<BoxShadow>? shadows;
//
//   final Clip clipBehavior;
//   final PerfsClipper clipper;
//
//   final Widget? child;
//
//   @override
//   Widget build(BuildContext context) {
//     Widget? clippedChild;
//     if (child != null && clipBehavior != Clip.none) {
//       clippedChild = ClipPath(
//         clipper: clipper,
//         clipBehavior: clipBehavior,
//         child: child,
//       );
//     } else {
//       clippedChild = child;
//     }
//
//     return CustomPaint(
//       painter: PerfsPainter(
//         count: count,
//         ratio: ratio,
//         radius: radius,
//         direction: direction,
//         color: color,
//         border: border,
//         shadows: shadows,
//       ),
//       child: clippedChild,
//     );
//   }
// }
