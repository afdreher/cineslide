// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: public_member_api_docs, avoid_print

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:cineslide/cinematic/cinematic.dart';
import 'package:cineslide/helpers/helpers.dart';
import 'package:cineslide/l10n/l10n.dart';
import 'package:cineslide/menu/menu.dart';
import 'package:cineslide/puzzle/puzzle.dart';
import 'package:cineslide/settings/settings.dart';
import 'package:cineslide/theme/theme.dart';

class App extends StatefulWidget {
  const App({Key? key, ValueGetter<PlatformHelper>? platformHelperFactory})
      : _platformHelperFactory = platformHelperFactory ?? getPlatformHelper,
        super(key: key);

  final ValueGetter<PlatformHelper> _platformHelperFactory;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// The path to local assets folder.
  static const localAssetsPrefix = 'assets/';

  static final audioAssets = [
    'assets/audio/shuffle.mp3',
    'assets/audio/click.mp3',
    'assets/audio/dumbbell.mp3',
    'assets/audio/sandwich.mp3',
    'assets/audio/skateboard.mp3',
    'assets/audio/success.mp3',
    'assets/audio/tile_move.mp3',
  ];

  late final PlatformHelper _platformHelper;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _platformHelper = widget._platformHelperFactory();

    _timer = Timer(const Duration(milliseconds: 20), () {
      precacheImage(
        Image.asset('assets/images/logo_flutter_color.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/logo_flutter_white.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/shuffle_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/timer_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/twitter_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/facebook_icon.png').image,
        context,
      );

      if (_platformHelper.isWeb) {
        for (final audioAsset in audioAssets) {
          prefetchToMemory(audioAsset);
        }
      }
    });
  }

  /// Prefetches the given [filePath] to memory.
  Future<void> prefetchToMemory(String filePath) async {
    if (_platformHelper.isWeb) {
      // We rely on browser caching here. Once the browser downloads the file,
      // the native implementation should be able to access it from cache.
      await http.get(Uri.parse('$localAssetsPrefix$filePath'));
      return;
    }
    throw UnimplementedError(
      'The function `prefetchToMemory` is not implemented '
      'for platforms other than Web.',
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(
            initialThemes: [
              const MuybridgeBuffaloTheme(),
              const ShuraevSmokeTheme(),
              const DetraySunsetTheme(),
              const ElliottPancakesTheme(),
            ],
          ),
        ),
      ],
      child: PlatformProvider(
        settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
        builder: (context) => PlatformApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routes: <String, WidgetBuilder>{
            '/settings': (BuildContext context) =>
                SettingsPage(title: context.l10n.settingsTitle),
            '/puzzle': (BuildContext context) => const PuzzlePage(),
          },
          material: (_, __) => MaterialAppData(
            theme: ThemeData(
              appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
              colorScheme: ColorScheme.fromSwatch(
                accentColor: const Color(0xFF13B9FF),
              ),
            ),
          ),
          home: const DefaultTextStyle(
            style: TextStyle(decoration: TextDecoration.none),
            maxLines: 1,
            child: VerticalMenuPage(),
          ),
        ),
      ),
    );
  }
}
