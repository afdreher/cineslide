// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/film/film.dart';
import 'package:cineslide/tile_image_provider/image_sequence_factory.dart';

class AnimatedFilmFrame extends StatelessWidget {
  const AnimatedFilmFrame(
      {Key? key,
      this.factory,
      this.image,
      required this.number,
      this.color = Colors.grey,
      this.direction = FilmDirection.horizontal,})
      : super(key: key);

  final ImageSequenceFactory? factory;
  final ImageProvider? image;
  final Color color;
  final int number;
  final FilmDirection direction;

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return _defaultFrame;
    }

    return FutureBuilder<Image?>(
      future: (factory ?? ImageSequenceFactory.instance)
          .getSequenceFromGif(image!)
          .then((value) => value.cover),
      builder: (BuildContext context, AsyncSnapshot<Image?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final Image img = snapshot.data as Image;
          return FilmFrame(
            image: img,
            color: color,
            number: number,
            direction: direction,
          );
        }
        return _defaultFrame;
      },
    );
  }

  FilmFrame get _defaultFrame {
    return FilmFrame(
      color: color,
      number: number,
      direction: direction,
    );
  }
}
