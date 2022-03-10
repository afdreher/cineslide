// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/film/film.dart';

// This really should be a cut instead of white, etc. but I'm going to leave it
// for now because of performance considerations.
class Perfs extends StatelessWidget {
  const Perfs(
      {Key? key,
      required this.count,
      this.ratio = 0.5,
      this.color = Colors.white,
      this.direction = FilmDirection.horizontal})
      : super(key: key);

  final int count;
  final double ratio;

  final Color color;

  final FilmDirection direction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // What's the total width?
      double limit = direction == FilmDirection.vertical
          ? constraints.maxHeight
          : constraints.maxWidth;
      double perCell = (limit / count) * ratio;

      double? width = direction == FilmDirection.vertical ? null : perCell;
      double? height = direction == FilmDirection.vertical ? perCell : null;

      List<Widget> cells = List.filled(
          count,
          SizedBox(
              height: height,
              width: width,
              child: Container(
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
              )));

      if (direction == FilmDirection.vertical) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: cells,
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: cells,
        );
      }
    });
  }
}
