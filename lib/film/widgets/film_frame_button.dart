// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/film/film.dart';

class FilmFrameButton extends StatelessWidget {
  const FilmFrameButton({
    Key? key,
    required this.assetName,
    required this.number,
    this.direction = FilmDirection.horizontal,
    this.onTap,
  }) : super(key: key);

  final String assetName;
  final int number;
  final FilmDirection direction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedFilmFrame(
        image: AssetImage(assetName),
        number: number,
        direction: direction,
      ),
    );
  }
}
