import 'dart:typed_data';

import 'package:flick_pick/features/main/widgets/movie_card_list.dart';
import 'package:flick_pick/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flick_pick/service_locator.dart';
import 'package:flick_pick/features/main/controller/main_controller.dart';

Uint8List onePixelPng() {
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

  group('MovieCardList', () {
    testWidgets('builds page view with items (non-editing)', (tester) async {
      final movies = List.generate(
        3,
        (i) => Movie(
          id: '$i',
          title: 'M$i',
          poster: onePixelPng(),
          desc: 'd',
          genre: 'g',
          directors: 'dir',
          watched: i % 2 == 0,
        ),
      );

      await tester.pumpWidget(
        wrapWithApp(
          MovieCardList(movies: movies, isEditing: false.obs, onTap: (_) {}),
        ),
      );

      // Expect at least the first movie title visible
      expect(find.text('M0'), findsOneWidget);

      // Ensure no Positioned misuse error and presence of PageView
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('builds reorderable list when editing', (tester) async {
      final movies = List.generate(
        3,
        (i) => Movie(
          id: '$i',
          title: 'R$i',
          poster: onePixelPng(),
          desc: 'd',
          genre: 'g',
          directors: 'dir',
          watched: false,
        ),
      );

      final isEditing = true.obs;

      await tester.pumpWidget(
        wrapWithApp(
          MovieCardList(
            movies: movies,
            isEditing: isEditing,
            onTap: (_) {},
            onReorder: (a, b) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ReorderableListView), findsAtLeastNWidgets(1));
    }, skip: true);
  });

  testWidgets('shows ReorderableListView when editing', (tester) async {
    final movies = List.generate(
      3,
      (i) => Movie(
        id: '$i',
        title: 'R$i',
        poster: onePixelPng(),
        desc: 'd',
        genre: 'g',
        directors: 'dir',
        watched: false,
      ),
    );
    final isEditing = true.obs;

    await tester.pumpWidget(
      wrapWithApp(
        MovieCardList(
          movies: movies,
          isEditing: isEditing,
          onTap: (_) {},
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final m = movies.removeAt(oldIndex);
            movies.insert(newIndex, m);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ReorderableListView), findsOneWidget);
  });

  testWidgets('reorders items on drag', (tester) async {
    final movies = List.generate(
      3,
      (i) => Movie(
        id: '$i',
        title: 'Item$i',
        poster: onePixelPng(),
        desc: 'd',
        genre: 'g',
        directors: 'dir',
        watched: false,
      ),
    );
    final isEditing = true.obs;

    await tester.pumpWidget(
      wrapWithApp(
        MovieCardList(
          movies: movies,
          isEditing: isEditing,
          onTap: (_) {},
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final m = movies.removeAt(oldIndex);
            movies.insert(newIndex, m);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Grab first drag handle icon and drag right
    final firstHandle = find.byIcon(Icons.drag_indicator).first;
    expect(firstHandle, findsOneWidget);

    final listFinder = find.byType(ReorderableListView);
    await tester.dragFrom(tester.getCenter(firstHandle), const Offset(320, 0));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    // Order should be changed (Item0 moved right)
    expect(movies.first.title != 'Item0', isTrue);
  });
}
