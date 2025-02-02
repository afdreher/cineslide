// ignore_for_file: prefer_const_constructors

// Package imports:
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cineslide/theme/theme.dart';
import '../../helpers/helpers.dart';
import 'package:cineslide/cinematic/cinematic.dart';

void main() {
  group('ThemeBloc', () {
    test('initial state is ThemeState', () {
      final themes = [MockPuzzleTheme()];
      expect(
        ThemeBloc(initialThemes: themes).state,
        equals(ThemeState(themes: themes)),
      );
    });

    group('ThemeChanged', () {
      late CinematicTheme theme;
      late List<CinematicTheme> themes;

      blocTest<ThemeBloc, ThemeState>(
        'emits new theme',
        setUp: () {
          theme = MockPuzzleTheme();
          themes = [MockPuzzleTheme(), theme];
        },
        build: () => ThemeBloc(initialThemes: themes),
        act: (bloc) => bloc.add(ThemeChanged(themeIndex: 1)),
        expect: () => <ThemeState>[
          ThemeState(themes: themes, theme: theme),
        ],
      );
    });

    // group('ThemeUpdated', () {
    //   late List<CinematicTheme> themes;
    //
    //   blocTest<ThemeBloc, ThemeState>(
    //     'replaces the theme identified by name '
    //     'in the list of themes',
    //     setUp: () {
    //       themes = [
    //         /// Name: 'Simple'
    //         SimpleTheme(),
    //
    //         ///  Name: 'Dashatar'
    //         GreenDashatarTheme(),
    //       ];
    //     },
    //     build: () => ThemeBloc(initialThemes: themes),
    //     act: (bloc) => bloc.add(ThemeUpdated(theme: YellowDashatarTheme())),
    //     expect: () => <ThemeState>[
    //       ThemeState(
    //         themes: const [
    //           /// Name: 'Simple'
    //           SimpleTheme(),
    //
    //           ///  Name: 'Dashatar'
    //           YellowDashatarTheme(),
    //         ],
    //         theme: YellowDashatarTheme(),
    //       ),
    //     ],
    //   );
    // });
  });
}
