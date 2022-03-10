// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

/// This is the storage for the decoded frames.
class ImageSequence {
  final List<imglib.Image> frames;
  final String name;
  final Duration duration;

  const ImageSequence({required this.name, required this.frames, required this.duration});

  static const ImageSequence empty = ImageSequence(name: "", frames: [], duration: Duration(seconds: 1));

  int get width {
    if (frames.isEmpty) {
      return 0;
    }
    return frames.first.width;
  }

  int get height {
    if (frames.isEmpty) {
      return 0;
    }
    return frames.first.height;
  }

  Image? get cover {
    return frame(0);
  }

  Image? frame(int number) {
    if (number >= 0 && number < frames.length) {
      return Image.memory(imglib.encodePng(frames[number]) as Uint8List);
    }
    return null;
  }
}
