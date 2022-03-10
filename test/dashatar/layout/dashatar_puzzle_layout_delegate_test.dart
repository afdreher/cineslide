// ignore_for_file: prefer_const_constructors

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:cineslide/audio_control/audio_control.dart';
import 'package:cineslide/dashatar/dashatar.dart';
import 'package:cineslide/models/models.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/theme/theme.dart';
import 'package:cineslide/timer/timer.dart';
import '../../helpers/helpers.dart';

void main() {
  group('DashatarPuzzleLayoutDelegate', () {
    late DashatarPuzzleLayoutDelegate layoutDelegate;
    late DashatarPuzzleBloc dashatarPuzzleBloc;
    late DashatarThemeBloc dashatarThemeBloc;
    late ThemeBloc themeBloc;
    late PuzzleBloc puzzleBloc;
    late PuzzleState state;
    late TimerBloc timerBloc;
    late AudioControlBloc audioControlBloc;

    setUp(() {
      layoutDelegate = DashatarPuzzleLayoutDelegate();

      dashatarPuzzleBloc = MockDashatarPuzzleBloc();
      final dashatarPuzzleState = DashatarPuzzleState(secondsToBegin: 3);
      whenListen(
        dashatarPuzzleBloc,
        Stream.value(dashatarPuzzleState),
        initialState: dashatarPuzzleState,
      );

      dashatarThemeBloc = MockDashatarThemeBloc();
      final themes = [GreenDashatarTheme()];
      final dashatarThemeState = DashatarThemeState(themes: themes);
      whenListen(
        dashatarThemeBloc,
        Stream.value(dashatarThemeState),
        initialState: dashatarThemeState,
      );

      themeBloc = MockThemeBloc();
      final theme = GreenDashatarTheme();
      final themeState = ThemeState(themes: [theme], theme: theme);
      when(() => themeBloc.state).thenReturn(themeState);

      puzzleBloc = MockPuzzleBloc();
      state = PuzzleState();
      when(() => puzzleBloc.state).thenReturn(state);

      timerBloc = MockTimerBloc();
      when(() => timerBloc.state).thenReturn(TimerState());

      audioControlBloc = MockAudioControlBloc();
      when(() => audioControlBloc.state).thenReturn(AudioControlState());
    });

    group('startSectionBuilder', () {
      testWidgets(
          'renders DashatarStartSection '
          'on a large display', (tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => SingleChildScrollView(
            child: layoutDelegate.startSectionBuilder(context, state),
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (widget) => widget is DashatarStartSection && widget.state == state,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders DashatarStartSection '
          'on a medium display', (tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => SingleChildScrollView(
            child: layoutDelegate.startSectionBuilder(context, state),
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (widget) => widget is DashatarStartSection && widget.state == state,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders DashatarStartSection '
          'on a small display', (tester) async {
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => SingleChildScrollView(
            child: layoutDelegate.startSectionBuilder(context, state),
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (widget) => widget is DashatarStartSection && widget.state == state,
          ),
          findsOneWidget,
        );
      });
    });

    group('endSectionBuilder', () {
      group('on a large display', () {
        testWidgets(
            'does not render DashatarPuzzleActionButton and '
            'DashatarThemePicker', (tester) async {
          tester.setLargeDisplaySize();

          await tester.pumpApp(
            Builder(
            builder: (BuildContext context) => SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(context, state),
            ),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarPuzzleActionButton), findsNothing);
          expect(find.byType(DashatarThemePicker), findsNothing);
        });

        testWidgets('renders DashatarCountdown', (tester) async {
          tester.setLargeDisplaySize();

          await tester.pumpApp(
            Builder(
            builder: (BuildContext context) => SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(context, state),
            ),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarCountdown), findsOneWidget);
        });
      });

      group('on a medium display', () {
        testWidgets('renders DashatarPuzzleActionButton', (tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
           Builder(
            builder: (BuildContext context) =>  SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(context, state),
            ),
           ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarPuzzleActionButton), findsOneWidget);
        });

        testWidgets('renders DashatarThemePicker', (tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
            Builder(
            builder: (BuildContext context) => SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(context, state),
            ),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarThemePicker), findsOneWidget);
        });

        testWidgets('renders DashatarCountdown', (tester) async {
          tester.setMediumDisplaySize();

          await tester.pumpApp(
           Builder(
            builder: (BuildContext context) =>  SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(context, state),
            ),
           ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarCountdown), findsOneWidget);
        });
      });

      group('on a small display', () {
        testWidgets('renders DashatarPuzzleActionButton', (tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            Builder(
            builder: (BuildContext context) => SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(context, state),
            ),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarPuzzleActionButton), findsOneWidget);
        });

        testWidgets('renders DashatarThemePicker', (tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            Builder(
            builder: (BuildContext context) => SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(context, state),
            ),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarThemePicker), findsOneWidget);
        });

        testWidgets('renders DashatarCountdown', (tester) async {
          tester.setSmallDisplaySize();

          await tester.pumpApp(
            Builder(
            builder: (BuildContext context) => SingleChildScrollView(
              child: layoutDelegate.endSectionBuilder(context, state),
            ),
            ),
            dashatarPuzzleBloc: dashatarPuzzleBloc,
            dashatarThemeBloc: dashatarThemeBloc,
            puzzleBloc: puzzleBloc,
            themeBloc: themeBloc,
            timerBloc: timerBloc,
            audioControlBloc: audioControlBloc,
          );

          expect(find.byType(DashatarCountdown), findsOneWidget);
        });
      });
    });

    group('backgroundBuilder', () {
      testWidgets(
          'renders DashatarThemePicker '
          'on a large display', (tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => Stack(
            children: [
              layoutDelegate.backgroundBuilder(context, state),
            ],
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarThemePicker), findsOneWidget);
      });

      testWidgets(
          'renders SizedBox '
          'on a medium display', (tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => Stack(
            children: [
              layoutDelegate.backgroundBuilder(context, state),
            ],
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarThemePicker), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets(
          'renders SizedBox '
          'on a small display', (tester) async {
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => Stack(
            children: [
              layoutDelegate.backgroundBuilder(context, state),
            ],
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarThemePicker), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('boardBuilder', () {
      final tiles = [
        const SizedBox(),
      ];

      testWidgets(
          'renders DashatarTimer and DashatarPuzzleBoard '
          'on a large display', (tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => SingleChildScrollView(
            child: layoutDelegate.boardBuilder(context, 4, tiles),
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarTimer), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is DashatarPuzzleBoard && widget.tiles == tiles,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders DashatarPuzzleBoard '
          'on a medium display', (tester) async {
        tester.setMediumDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => SingleChildScrollView(
            child: layoutDelegate.boardBuilder(context, 4, tiles),
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarTimer), findsNothing);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is DashatarPuzzleBoard && widget.tiles == tiles,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders DashatarPuzzleBoard '
          'on a small display', (tester) async {
        tester.setSmallDisplaySize();

        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => SingleChildScrollView(
            child: layoutDelegate.boardBuilder(context, 4, tiles),
          ),
          ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(find.byType(DashatarTimer), findsNothing);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is DashatarPuzzleBoard && widget.tiles == tiles,
          ),
          findsOneWidget,
        );
      });
    });

    group('tileBuilder', () {
      testWidgets('renders DashatarPuzzleTile', (tester) async {
        final tile = Tile(
          value: 1,
          correctPosition: Position(x: 1, y: 1),
          currentPosition: Position(x: 1, y: 2),
        );

        await tester.pumpApp(
         Builder(
            builder: (BuildContext context) =>  Material(
            child: layoutDelegate.tileBuilder(context, tile, state),
          ),
         ),
          dashatarPuzzleBloc: dashatarPuzzleBloc,
          dashatarThemeBloc: dashatarThemeBloc,
          puzzleBloc: puzzleBloc,
          themeBloc: themeBloc,
          timerBloc: timerBloc,
          audioControlBloc: audioControlBloc,
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is DashatarPuzzleTile &&
                widget.tile == tile &&
                widget.state == state,
          ),
          findsOneWidget,
        );
      });
    });

    group('whitespaceTileBuilder', () {
      testWidgets('renders SizedBox', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) => layoutDelegate.whitespaceTileBuilder(context),
          ),
        );

        expect(
          find.byType(SizedBox),
          findsOneWidget,
        );
      });
    });

    test('supports value comparisons', () {
      expect(
        DashatarPuzzleLayoutDelegate(),
        equals(DashatarPuzzleLayoutDelegate()),
      );
    });
  });
}
