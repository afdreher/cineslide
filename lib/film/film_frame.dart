// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/film/film.dart';

class Size {
  const Size({required this.height, required this.width});

  final double height;
  final double width;
}

class Measurements {
  const Measurements({required this.frame, required this.picture});

  final Size frame;
  final Size picture;
}

class FilmFrame extends StatelessWidget {
  const FilmFrame({
    Key? key,
    this.image,
    this.color = Colors.white,
    this.number = 22,
    this.text,
    this.direction = FilmDirection.horizontal,
    int? perfCount,
    double? perfPadding,
    double? perfHeight,
    this.perfRatio = 0.5,
    this.aspect = 1.0,
    this.exposedFilmColor = FilmColors.exposedColor,
    this.unexposedFilmColor = FilmColors.exposedColor,
    this.textColor = FilmColors.textColor,
    double? fontSize,
    this.child,
  })  : perfCount = perfCount ?? 9,
        perfPadding = perfPadding ?? 6,
        perfHeight = perfHeight ?? 20,
        fontSize = fontSize ?? 14.0,
        super(key: key);

  // If the child is specified, the image will be ignored
  final Image? image;
  final Widget? child;

  final int number;
  final String? text;

  final Color color;
  final Color exposedFilmColor;
  final Color unexposedFilmColor;
  final Color textColor;

  final FilmDirection direction;

  final double aspect;
  final int perfCount;

  final double perfPadding;
  final double perfHeight;
  final double perfRatio;

  final double fontSize;
  final double size = 20.0;
  final double textWidth = 12.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      switch (direction) {
        case FilmDirection.vertical:
          return _verticalFilm(context, constraints);
        default:
          return _horizontalFilm(context, constraints);
      }
    });
  }

  Measurements computeMeasurements(
      BoxConstraints constraints, EdgeInsets insets) {
    // Rounding makes the step more consistent
    double picture = min(constraints.maxWidth - insets.horizontal,
        constraints.maxHeight - insets.vertical);

    double pictureHeight = (picture * aspect).roundToDouble();

    double height = (pictureHeight + insets.vertical).roundToDouble();
    double width = (picture + insets.horizontal).roundToDouble();

    return Measurements(
        frame: Size(height: height, width: width),
        picture: Size(height: pictureHeight, width: picture));
  }

  Widget _horizontalFilm(BuildContext context, BoxConstraints constraints) {
    final Perfs strip = _perfStrip();

    //      [FONT]  [S] [TXT] [6]
    // 46 = 1 + 14 + 5 + 20 + 6
    // Font size is 14.  Top padding is 1, for 15, 5 is the spacing top; 6 is the spacing bottom

    EdgeInsets pictureInset = EdgeInsets.symmetric(
        horizontal: 8.0, vertical: 2.0 * perfPadding + fontSize + perfHeight);

    final Measurements measurements =
        computeMeasurements(constraints, pictureInset);

    Widget theChild = child ??
        Container(
          color: color,
          foregroundDecoration: image != null
              ? BoxDecoration(
                  image:
                      DecorationImage(image: image!.image, fit: BoxFit.cover),
                )
              : null,
        );

    return SizedBox(
      height: measurements.frame.height,
      width: measurements.frame.width,
      child: Stack(
        children: <Widget>[
          Container(
            color: unexposedFilmColor,
            child: Padding(
              padding: pictureInset,
              child: SizedBox(
                height: measurements.picture.height,
                width: measurements.picture.width,
                child: Stack(children: [
                  Container(
                    color: exposedFilmColor,
                  ),
                  theChild
                ]),
              ),
            ),
          ),
          if (text != null)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 1),
                child: _devpostText(),
              ),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: perfPadding + fontSize, bottom: perfPadding),
              child: SizedBox(
                height: perfHeight,
                child: strip,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: perfPadding, bottom: perfPadding + fontSize),
              child: SizedBox(
                height: perfHeight,
                child: strip,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 0, bottom: 1),
              child: _filmNumber(),
            ),
          )
        ],
      ),
    );
  }

  Widget _verticalFilm(BuildContext context, BoxConstraints constraints) {
    final Perfs strip = _perfStrip();

    const EdgeInsets pictureInset =
        EdgeInsets.symmetric(horizontal: 46.0, vertical: 8.0);

    final Measurements measurements =
        computeMeasurements(constraints, pictureInset);

    Widget theChild = child ??
        Container(
          color: color,
          foregroundDecoration: image != null
              ? BoxDecoration(
                  image:
                      DecorationImage(image: image!.image, fit: BoxFit.cover),
                )
              : null,
        );

    return SizedBox(
      height: measurements.frame.height,
      width: measurements.frame.width,
      child: Stack(
        children: <Widget>[
          Container(
            color: unexposedFilmColor,
            child: Padding(
              padding: pictureInset,
              child: SizedBox(
                height: measurements.picture.height,
                width: measurements.picture.width,
                child: Stack(children: [
                  Container(
                    color: exposedFilmColor,
                  ),
                  theChild
                ]),
              ),
            ),
          ),
          if (text != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 1, bottom: 12),
                child: RotatedBox(
                  child: _devpostText(),
                  quarterTurns: 3,
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: size, right: 6),
              child: SizedBox(
                  width: size, height: measurements.frame.height, child: strip),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(left: 6, right: size),
              child: SizedBox(
                width: size,
                height: measurements.frame.height,
                child: strip,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 1, bottom: 12),
              child: RotatedBox(
                child: _filmNumber(),
                quarterTurns: 3,
              ),
            ),
          )
        ],
      ),
    );
  }

  Text? _devpostText() {
    if (text != null) {
      return Text(
        text!,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      );
    }
    return null;
  }

  Text _filmNumber() {
    return Text(
      '▷ ${number}A',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  Perfs _perfStrip() {
    return Perfs(
      count: perfCount,
      ratio: perfRatio,
      direction: direction,
    );
  }
}
