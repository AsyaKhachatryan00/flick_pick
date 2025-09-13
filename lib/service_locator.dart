import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'core/widgets/utils/shared_prefs.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  await _initSharedPrefs();
}

Future<void> _initSharedPrefs() async {
  final sharedPrefs = SharedPrefs();

  try {
    await sharedPrefs.init();
  } catch (e) {
    log('Local storage doesnt init');
  }

  locator.registerSingleton<SharedPrefs>(sharedPrefs);
}
