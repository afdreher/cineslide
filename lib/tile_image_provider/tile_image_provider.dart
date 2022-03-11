import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

import 'package:cineslide/tile_image_provider/image_sequence.dart';
import 'package:cineslide/tile_image_provider/image_sequence_factory.dart';

/// This is the storage for the decoded frames.
class TileImageProvider {
  /// There are two ways to create a tile image provider.  Either you can create
  /// a provider from an image sequence with the provided rows and columns, or
  /// you can ask for one with an image provider
  TileImageProvider(
      {required this.sequence, required this.rowCount, int? columnCount})
      : columnCount = columnCount ?? rowCount,
        tileCount = rowCount * (columnCount ?? rowCount) {
    // Just compute these once.  These define the relative cut points.  Start is
    // your current index; end is the next index.  By caching these instead of
    // computing the divide every time, we keep the cuts constant.

    final int width = sequence.width;
    final int height = sequence.height;

    rowCutHeight = ((1 / rowCount) * height).truncate();
    columnCutWidth = ((1 / this.columnCount) * width).truncate();
    rowCuts = [
      for (var i = 0; i < (rowCount + 1); i += 1)
        ((i / rowCount) * height).round()
    ];
    columnCuts = [
      for (var i = 0; i < (this.columnCount + 1); i += 1)
        ((i / this.columnCount) * width).round()
    ];
  }

  late final List<int> rowCuts;
  late final List<int> columnCuts;
  late final int rowCutHeight;
  late final int columnCutWidth;

  static Future<TileImageProvider> fromImage(
      {required ImageProvider provider,
      int? framesPerSecond,
      required int rowCount,
      int? columnCount}) async {
    ImageSequence sequence = await ImageSequenceFactory.instance
        .getSequenceFromGif(provider, framesPerSecond: framesPerSecond);
    TileImageProvider tileProvider = TileImageProvider(
        sequence: sequence, rowCount: rowCount, columnCount: columnCount);
    return Future.value(tileProvider);
  }

  /// The image sequence represented by this provider
  final ImageSequence sequence;

  /// The number of tiles in a row / column.
  final int rowCount;
  final int columnCount;
  final int tileCount;

  final Map<int, Image> _cachedTiles = {};

  Duration get duration => sequence.duration;
  int get frameCount => sequence.frames.length;

  /// Compute all of the tiles, such as during a load sequence.  These could be
  /// a bit slow since it is using highly unoptimized code.
  Future<TileImageProvider> generateAllTiles() async {
    for (int i = 0; i < sequence.frames.length; i++) {
      _generateTiles(frame: i);
    }
    return this; // Allow for chaining
  }

  int _getKey({required int tile, required int frame}) {
    // Basically, just a matrix.
    return frame * (tileCount + 1) + tile;
  }

  void _generateTiles({required int frame}) {
    // Get the image from the sequence
    if (frame < 0 || frame >= frameCount) {
      throw ArgumentError.value(frame, null,
          'Frame $frame is out of bounds. Valid frames are 0..$frameCount');
    }

    final imglib.Image img = sequence.frames[frame];

    int start = 1;
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < columnCount; c++) {
        // Get the tile which is from
        imglib.Image tile = imglib.copyCrop(
            img, columnCuts[c], rowCuts[r], columnCutWidth, rowCutHeight);
        Image tileImage = Image.memory(imglib.encodePng(tile) as Uint8List, gaplessPlayback: true,);
        _cachedTiles[_getKey(tile: start + c, frame: frame)] = tileImage;
      }
      start += columnCount;
    }
  }

  Image? relativeImageFor({required int tile, required double relativeFrame}) {
    // Relative frame computes the frame # interpolating [0, 1]
    int frame = (relativeFrame * (frameCount - 1)).round();
    return imageFor(tile: tile, frame: frame);
  }

  Image? imageFor({required int tile, required int frame}) {
    int key = _getKey(tile: tile, frame: frame);
    if (_cachedTiles.containsKey(key)) {
      return _cachedTiles[key];
    }

    // It's not cached... Generate all of the tiles for the frame
    _generateTiles(frame: frame);
    return _cachedTiles[key];
  }
}
