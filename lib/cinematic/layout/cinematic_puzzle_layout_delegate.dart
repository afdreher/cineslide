// Flutter imports:
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/layout/layout.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/tile_image_provider/tile_image_provider.dart';


/// {@template cinematic_puzzle_layout_delegate}
/// {@endtemplate}
class CinematicPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro cinematic_puzzle_layout_delegate}
  const CinematicPuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(BuildContext context, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __, child) => child!,
      medium: (_, __, child) => child!,
      large: (_, __, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => CinematicStartSection(state: state),
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
          small: (_, __, child) => const CinematicPuzzleActionButton(),
          medium: (_, __, child) => const CinematicPuzzleActionButton(),
          large: (_, __, ___) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 54,
        ),
        const ResponsiveGap(
          large: 130,
        ),
        const CinematicCountdown(),
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
        large: (_, __, child) => Container(),
      ),
    );
  }

  @override
  Widget boardBuilder(BuildContext context, int size, List<Widget> tiles) {
    // Use the bloc to get the current provider
    TileImageProvider tileImageProvider = Provider.of<TileImageProvider>(context);

    return Stack(
      children: [
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: ResponsiveLayoutBuilder(
            small: (_, __, child) => const SizedBox(),
            medium: (_, __, child) => const SizedBox(),
            large: (_, __, child) => const CinematicTimer(),
          ),
        ),
        Column(
          children: [
            const ResponsiveGap(
              small: 21,
              medium: 34,
              large: 96,
            ),
            CinematicPuzzleBoard(tiles: tiles, tileImageProvider: tileImageProvider,),
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
    // Use the bloc to get the current provider
    TileImageProvider tileImageProvider = Provider.of<TileImageProvider>(context);

    return CinematicPuzzleTile(
      tile: tile,
      state: state,
      tileImageProvider: tileImageProvider,
    );
  }

  @override
  Widget whitespaceTileBuilder(BuildContext context, {Tile? tile, PuzzleState? state}) {
    // final ImageSequenceFactory imageFactory = ImageSequenceFactory.instance;
    //
    // return SizedBox(
    //   height: 100,
    //     width: 100,
    //     child: FutureBuilder<ImageSequence>(
    //         future: imageFactory.getSequenceFromGif(
    //             const AssetImage('assets/scenes/muybridge_buffalo.gif')),
    //         builder:
    //             (BuildContext context, AsyncSnapshot<ImageSequence> snapshot) {
    //           if (snapshot.hasData) {
    //             final ImageSequence sequence = snapshot.data as ImageSequence;
    //             return AnimatedImageSequence(sequence: sequence,);
    //           } else {
    //             return Container(
    //               color: Colors.red,
    //             );
    //           }
    //         }));
    return Container();
  }

  @override
  List<Object?> get props => [];
}

