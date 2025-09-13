import 'dart:typed_data';

import 'package:flick_pick/features/main/widgets/movie_card.dart';
import 'package:flick_pick/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flick_pick/service_locator.dart';
import 'package:flick_pick/features/main/controller/main_controller.dart';

Uint8List onePixelPng() {
  // 1x1 transparent PNG
  return Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x60,
    0x00,
    0x00,
    0x00,
    0x02,
    0x00,
    0x01,
    0xE2,
    0x21,
    0xBC,
    0x33,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]);
}

Widget wrapWithApp(Widget child) {
  return GetMaterialApp(
    home: ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await initDependencies();
    if (!Get.isRegistered<MainController>()) {
      Get.put(MainController());
    }
  });

  setUp(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.devicePixelRatioTestValue = 3.0;
    binding.window.physicalSizeTestValue = const Size(1440, 3040);
  });

  tearDown(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
  });

  tearDownAll(() async {
    if (Get.isRegistered<MainController>()) {
      Get.delete<MainController>();
    }
  });

  group('MovieCard', () {
    testWidgets('renders without throwing and shows title', (tester) async {
      final movie = Movie(
        id: '1',
        title: 'Test Movie',
        poster: onePixelPng(),
        desc: 'desc',
        genre: 'genre',
        directors: 'dir',
        watched: false,
      );
      var tappedMovieId = '';

      await tester.pumpWidget(
        wrapWithApp(
          MovieCard(
            movie: movie,
            onTap: (m) => tappedMovieId = m.id,
            scale: 1.0,
            isEditing: false.obs,
            opacity: 1.0,
          ),
        ),
      );

      expect(find.text('Test Movie'), findsOneWidget);
      expect(tappedMovieId, isEmpty);
    });

    testWidgets('tapping status button triggers onTap callback', (
      tester,
    ) async {
      final movie = Movie(
        id: '2',
        title: 'Another',
        poster: onePixelPng(),
        desc: 'desc',
        genre: 'genre',
        directors: 'dir',
        watched: true,
      );
      Movie? tapped;

      await tester.pumpWidget(
        wrapWithApp(
          MovieCard(
            movie: movie,
            onTap: (m) => tapped = m,
            scale: 1.0,
            isEditing: false.obs,
            opacity: 1.0,
          ),
        ),
      );

      expect(find.text('watched'), findsOneWidget);
      await tester.tap(find.text('watched'));
      await tester.pumpAndSettle();

      expect(tapped, isNotNull);
      expect(tapped!.id, equals('2'));
    });

    testWidgets('tapping card opens bottom sheet', (tester) async {
      final movie = Movie(
        id: '3',
        title: 'BottomSheet',
        poster: onePixelPng(),
        desc: 'd',
        genre: 'g',
        directors: 'd',
        watched: false,
      );

      await tester.pumpWidget(
        wrapWithApp(
          MovieCard(
            movie: movie,
            onTap: (_) {},
            scale: 1.0,
            isEditing: false.obs,
            opacity: 1.0,
          ),
        ),
      );

      await tester.tap(find.byType(MovieCard));
      await tester.pumpAndSettle();

      // Bottom sheet should appear in the tree (Get.bottomSheet uses a Modal route)
      expect(find.byType(BottomSheet), findsWidgets);
    });
  });
}
