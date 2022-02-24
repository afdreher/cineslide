import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  const OutlinedText(this.text,
      {Key? key,
      required this.style,
      this.strokeColor = Colors.black,
      this.strokeWidth = 1.0})
      : super(key: key);

  final String text;
  final TextStyle style;
  final Color strokeColor;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final TextStyle outlinedStyle = style.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = strokeColor);

    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: outlinedStyle,
        ),
        // Solid text as fill.
        Text(
          text,
          style: style,
        ),
      ],
    );
  }
}
