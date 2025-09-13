import 'dart:typed_data';

import 'package:flick_pick/core/config/constants/storage_keys.dart';
import 'package:flick_pick/core/widgets/utils/shared_prefs.dart';
import 'package:flick_pick/models/movie.dart';
import 'package:flick_pick/service_locator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:uuid/uuid.dart';

class MainController extends GetxController {
  final storage = locator<SharedPrefs>();

  RxBool isPremium = false.obs;
  RxBool isNotsOn = true.obs;

  final RxInt screenIndex = 0.obs;
  final RxList<Movie> movies = <Movie>[].obs;

  Uint8List? filePath;

  @override
  void onInit() {
    super.onInit();

    storage.init().then((_) {
      getPremium();
      isNotsOn.value = getNots();
    });

    movies.value = getMovies();
  }

  void getPremium() => isPremium.value = storage.getBool(StorageKeys.isPremium);

  Future<void> setPremium() async {
    isPremium.value = await storage.setBool(StorageKeys.isPremium, true);
    Get.back();
  }

  bool getNots() => storage.getBool(StorageKeys.isNotificationsOn);

  Future<void> setNots(bool value) async {
    await storage.setBool(StorageKeys.isNotificationsOn, value);
    isNotsOn.value = value;
  }

  void onFilePicked(ImageSource source) async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      filePath = await picked.readAsBytes();
    }

    update();
  }

  List<Movie> getMovies() {
    List<String> storedEntries = storage.getStringList(StorageKeys.notes);

    return storedEntries.map((entry) => Movie.decode(entry)).toList();
  }

  void onBackTap() {
    filePath = null;
    Get.back();
  }

  Future<void> addMovie({required FormGroup form}) async {
    final movie = Movie(
      id: const Uuid().v4(),
      title: form.control('title').value,
      poster: filePath,
      desc: form.control('desc').value,
      genre: form.control('genre').value,
      directors: form.control('directors').value,
    );

    movies
      ..add(movie)
      ..refresh();
    await saveMovie(movie);

    onBackTap();
    update();
  }

  void updateWatched(Movie movie) {
    movie.watched = !movie.watched;
    update();
  }

  Future<void> saveMovie(Movie entry) async {
    List<String> existingEntries = storage.getStringList(StorageKeys.notes);
    existingEntries.add(entry.encode());

    await storage.setStringList(StorageKeys.notes, existingEntries);
  }
}
