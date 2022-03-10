// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cineslide/dashatar/dashatar.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/tile_image_provider/image_sequence.dart';
import 'package:cineslide/tile_image_provider/image_sequence_factory.dart';

/// {@template dashatar_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [DashatarTheme].
/// {@endtemplate}
class DashatarPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro dashatar_puzzle_layout_delegate}
  const DashatarPuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(BuildContext context, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __, child) => child!,
      medium: (_, __, child) => child!,
      large: (_, __, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => DashatarStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(BuildContext context, PuzzleState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const ResponsiveGap(
          small: 23,
          medium: 32,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __, child) => const DashatarPuzzleActionButton(),
          medium: (_, __, child) => const DashatarPuzzleActionButton(),
          large: (_, __, ___) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 54,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __, child) => const DashatarThemePicker(),
          medium: (_, __, child) => const DashatarThemePicker(),
          large: (_, __, child) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 54,
        ),
        const ResponsiveGap(
          large: 130,
        ),
        const DashatarCountdown(),
      ],
    );
  }

  @override
  Widget backgroundBuilder(BuildContext context, PuzzleState state) {
    return Positioned(
      bottom: 74,
      right: 50,
      child: ResponsiveLayoutBuilder(
        small: (_, __, child) => const SizedBox(),
        medium: (_, __, child) => const SizedBox(),
        large: (_, __, child) => const DashatarThemePicker(),
      ),
    );
  }

  @override
  Widget boardBuilder(BuildContext context, int size, List<Widget> tiles) {
    return Stack(
      children: [
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: ResponsiveLayoutBuilder(
            small: (_, __, child) => const SizedBox(),
            medium: (_, __, child) => const SizedBox(),
            large: (_, __, child) => const DashatarTimer(),
          ),
        ),
        Column(
          children: [
            const ResponsiveGap(
              small: 21,
              medium: 34,
              large: 96,
            ),
            DashatarPuzzleBoard(tiles: tiles),
            const ResponsiveGap(
              large: 96,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(BuildContext context, Tile tile, PuzzleState state) {
    return DashatarPuzzleTile(
      tile: tile,
      state: state,
    );
  }

  @override
  Widget whitespaceTileBuilder(BuildContext context, {Tile? tile, PuzzleState? state}) {
    final ImageSequenceFactory imageFactory = ImageSequenceFactory.instance;


    return SizedBox(
      height: 100,
        width: 100,
        child: FutureBuilder<ImageSequence>(
            future: imageFactory.getSequenceFromGif(
                const AssetImage('assets/scenes/muybridge_buffalo.gif')),
            builder:
                (BuildContext context, AsyncSnapshot<ImageSequence> snapshot) {
              if (snapshot.hasData) {
                final ImageSequence sequence = snapshot.data as ImageSequence;
                return AnimatedImageSequence(sequence: sequence,);
              } else {
                return Container(
                  color: Colors.red,
                );
              }
            }));
  }

  @override
  List<Object?> get props => [];
}

class AnimatedImageSequence extends StatefulWidget {
  const AnimatedImageSequence({Key? key, required this.sequence})
      : super(key: key);

  final ImageSequence sequence;

  @override
  _AnimatedImageSequenceState createState() => _AnimatedImageSequenceState();
}

class _AnimatedImageSequenceState extends State<AnimatedImageSequence>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: widget.sequence.frames.length - 1).animate(_controller);
    _controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, _) {
        Image? f =  widget.sequence.frame((_animation.value).floor());
        if (f != null) {
          return f;
        }
        return Container();
      },
    );
  }
}
