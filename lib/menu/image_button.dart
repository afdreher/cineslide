// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/tile_image_provider/image_sequence_factory.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    Key? key,
    required this.asset,
    BoxFit? fit,
    required this.isGif,
    this.framesPerSecond,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
  })  : fit = fit ?? BoxFit.cover,
        super(key: key);

  const ImageButton.asset({
    Key? key,
    required String asset,
    BoxFit? fit,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
  }) : this(
          key: key,
          asset: asset,
          fit: fit,
          isGif: false,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
        );

  const ImageButton.gif({
    Key? key,
    required String asset,
    int? framesPerSecond,
    BoxFit? fit,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
  }) : this(
          key: key,
          asset: asset,
          fit: fit,
          isGif: true,
          framesPerSecond: framesPerSecond,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
        );

  final bool isGif;
  final int? framesPerSecond;
  final String asset;
  final BoxFit fit;

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;

  @override
  Widget build(BuildContext context) {
    final image = AssetImage(asset);
    Widget? child;

    if (isGif) {
      final baseImage = AssetImage(asset);
      child = FutureBuilder<Image?>(
          future: _getImage(baseImage),
          builder: (BuildContext context, AsyncSnapshot<Image?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final Image img = snapshot.data as Image;
              return Container(
                foregroundDecoration: BoxDecoration(
                  image: DecorationImage(image: img.image, fit: fit),
                ),
              );
            }
            return Container();
          });
    } else {
      child = Container(
        foregroundDecoration: BoxDecoration(
          image: DecorationImage(image: image, fit: fit),
        ),
      );
    }

    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
      ),
      onPressed: onPressed,
      onFocusChange: onFocusChange,
      onHover: onHover,
      onLongPress: onLongPress,
      child: child,
    );
  }

  Future<Image?> _getImage(ImageProvider baseImage) {
    return ImageSequenceFactory.instance
              .getSequenceFromGif(baseImage, framesPerSecond: framesPerSecond)
              .then((value) => value.cover);
  }
}
