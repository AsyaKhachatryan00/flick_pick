import 'dart:typed_data';
import 'package:flick_pick/core/config/constants/storage_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flick_pick/service_locator.dart';
import 'package:flick_pick/core/widgets/utils/shared_prefs.dart';
import 'package:flick_pick/features/main/controller/main_controller.dart';
import 'package:flick_pick/models/movie.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<void> init() async {
  SharedPreferences.setMockInitialValues({});
  await initDependencies();
  if (!Get.isRegistered<MainController>()) {
    Get.put(MainController());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
  setUpAll(() async {
    await init();
    await locator<SharedPrefs>().init();
  });

  tearDownAll(() {
    if (Get.isRegistered<MainController>()) Get.delete<MainController>();
  });

  test('initial state loads from storage', () async {
    final prefs = locator<SharedPrefs>();
    await prefs.init();
    await prefs.setStringList(StorageKeys.notes, []);

    final c = Get.find<MainController>()..onInit();
    expect(c.movies, isA<RxList<Movie>>());
  });

  test('setPremium stores and reflects value', () async {
    final c = Get.find<MainController>();
    await c.setPremium();
    expect(c.isPremium.value, isTrue);
  });

  test('notifications toggle persists', () async {
    final c = Get.find<MainController>();
    await c.setNots(false);
    expect(c.isNotsOn.value, isFalse);
    expect(c.getNots(), isFalse);
  });

  test('addMovie appends and saves', () async {
    final c = Get.find<MainController>();
    final count = c.movies.length;

    c.filePath = Uint8List.fromList([1, 2, 3]);
    final form = FormGroup({
      'title': FormControl<String>(value: 'Title'),
      'desc': FormControl<String>(value: 'Desc'),
      'genre': FormControl<String>(value: 'Genre'),
      'directors': FormControl<String>(value: 'Dir'),
    });

    await c.addMovie(form: form);
    expect(c.movies.length, count + 1);
    expect(c.movies.last.title, 'Title');

    // storage contains it
    final stored = locator<SharedPrefs>().getStringList(StorageKeys.notes);
    expect(stored.isNotEmpty, isTrue);
  });

  test('updateWatched toggles flag', () {
    final c = Get.find<MainController>();
    final m = Movie(id: 'x', title: 't', desc: '', genre: '', directors: '');
    final initial = m.watched;
    c.updateWatched(m);
    expect(m.watched, !initial);
  });

  test('getMovies decodes from storage', () async {
    final c = Get.find<MainController>();
    final saved = c.getMovies(); 
    expect(saved, isA<List<Movie>>());
  });
}
