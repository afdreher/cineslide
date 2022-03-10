// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

// Project imports:
import 'package:cineslide/tile_image_provider/image_sequence.dart';

class ImageSequenceFactory {
  static final ImageSequenceFactory instance = ImageSequenceFactory();

  static const int kDefaultFramesPerSecond = 15;

  final Map<String, ImageSequence> _cachedImages = {};

  String _getKeyImage(ImageProvider provider) {
    return provider is AssetImage
        ? provider.assetName
        : provider is MemoryImage
            ? provider.bytes.toString()
            : "";
  }

  Future<ImageSequence> getSequenceFromGif(ImageProvider provider,
      {int? framesPerSecond}) async {
    ImageSequence sequence = ImageSequence.empty;

    dynamic data;
    String key = _getKeyImage(provider);
    if (_cachedImages.containsKey(key)) {
      return _cachedImages[key]!;
    }

    if (provider is AssetImage) {
      AssetBundleImageKey key =
          await provider.obtainKey(const ImageConfiguration());
      data = await key.bundle.load(key.name);
    } else if (provider is FileImage) {
      data = await provider.file.readAsBytes();
    } else if (provider is MemoryImage) {
      data = provider.bytes;
    }

    final decoder = imglib.GifDecoder();
    final animation = decoder.decodeAnimation(data.buffer.asUint8List());
    if (animation == null) {
      return Future.value(sequence);
    }

    final frameList = animation.frames;
    Duration duration;
      if (frameList.isEmpty) {
        duration = const Duration(seconds: 1);
      } else {
        int ms =
            ((frameList.length / (framesPerSecond ?? kDefaultFramesPerSecond)) *
                    1000)
                .round();
        duration = Duration(milliseconds: ms);
      }

    sequence =
          ImageSequence(name: key, frames: animation.frames, duration: duration);
      _cachedImages.putIfAbsent(key, () => sequence);

    return Future.value(sequence);

    // Codec? codec = await PaintingBinding.instance
    //     ?.instantiateImageCodec(data.buffer.asUint8List());
    //
    // if (codec != null) {
    //   List<ImageInfo> frameList = [];
    //   for (int i = 0; i < codec.frameCount; i++) {
    //     FrameInfo frameInfo = await codec.getNextFrame();
    //     //scale ??
    //     frameList.add(ImageInfo(image: frameInfo.image));
    //   }
    //   Duration duration;
    //   if (frameList.isEmpty) {
    //     duration = const Duration(seconds: 1);
    //   } else {
    //     int ms =
    //         ((frameList.length / (framesPerSecond ?? kDefaultFramesPerSecond)) *
    //                 1000)
    //             .round();
    //     duration = Duration(milliseconds: ms);
    //   }
    //   sequence =
    //       ImageSequence(name: key, frames: frameList, duration: duration);
    //   _cachedImages.putIfAbsent(key, () => sequence);
    // }
    // return sequence;
  }
}
