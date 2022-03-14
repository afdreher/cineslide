// // Dart imports:
// import 'dart:ui' as ui;
//
// // Flutter imports:
// import 'package:flutter/material.dart';
//
// // Package imports:
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:gap/gap.dart';
//
// // Project imports:
// import 'package:cineslide/film/film.dart';
// import 'package:cineslide/typography/typography.dart';
//
// class HorizontalMenuPage extends StatelessWidget {
//   const HorizontalMenuPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     const double sigma = 12.0;
//
//     return PlatformScaffold(
//       body: Stack(
//         children: <Widget>[
//           ImageFiltered(
//             imageFilter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
//             child: Container(
//               decoration: const BoxDecoration(
//                   image: DecorationImage(
//                 image: AssetImage(
//                     'assets/images/muybridge/gallop_thoroughbred_bay_mare_annie.jpg'),
//                 fit: BoxFit.cover,
//               )),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Gap(16),
//                   SafeArea(
//                     child: OutlinedText(
//                       'Cineslide',
//                       strokeColor: const Color.fromRGBO(88, 82, 75, 1.0),
//                       strokeWidth: 2.0,
//                       style: Theme.of(context).textTheme.headline2!.copyWith(
//                             color: const Color.fromRGBO(243, 233, 213, 1.0),
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ),
//                   // const Gap(16),
//                   // const Text('Now Playing'),
//                   const Gap(32),
//                   CarouselSlider(
//                     items: <Widget>[
//                       const FilmFrame(
//                         color: Colors.red,
//                         number: 22,
//                       ),
//                       const FilmFrameButton(
//                           assetName: 'assets/scenes/muybridge_buffalo.gif',
//                           number: 23),
//                       FilmFrame(
//                         image: Image.asset(
//                           'assets/images/dashatar/gallery/blue.png',
//                         ),
//                         color: Colors.blue,
//                         number: 24,
//                       ),
//                       FilmFrame(
//                         image: Image.asset(
//                           'assets/images/dashatar/gallery/yellow.png',
//                         ),
//                         color: Colors.orange,
//                         number: 25,
//                       ),
//                     ],
//                     options: CarouselOptions(
//                       height: 360,
//                       viewportFraction: 0.8,
//                       autoPlay: false,
//                       enlargeCenterPage: false,
//                       // onPageChanged: (_, __) {
//                       //   print('Changing!');
//                       // },
//                       scrollDirection: Axis.horizontal,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//
//     // return PlatformScaffold(
//     //   body:
//     // );
//   }
// }
