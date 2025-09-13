import 'package:flick_pick/core/route/routes.dart';
import 'package:flick_pick/core/widgets/utils/shared_prefs.dart';
import 'package:flick_pick/features/home/home_screen.dart';
import 'package:flick_pick/features/main/main_screen.dart';
import 'package:flick_pick/features/premium/premium_screen.dart';
import 'package:flick_pick/features/settings/settings_screen.dart';
import 'package:flick_pick/features/splash/splash_screen.dart';
import 'package:flick_pick/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoute {
  factory AppRoute() => AppRoute._internal();

  AppRoute._internal();
  final main = Get.nestedKey(0);
  final nested = Get.nestedKey(1);

  Bindings? initialBinding() {
    return BindingsBuilder(() {
      locator<SharedPrefs>();
    });
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteLink.splash:
        return pageRouteBuilder(page: SplashScreen());

      case RouteLink.main:
        return pageRouteBuilder(page: MainScreen());

      case RouteLink.home:
        return pageRouteBuilder(page: HomeScreen());

      case RouteLink.settings:
        return pageRouteBuilder(page: SettingsScreen());

      case RouteLink.premium:
        return pageRouteBuilder(page: PremiumScreen());

      default:
        return pageRouteBuilder(
          page: Scaffold(body: Container(color: Colors.red)),
        );
    }
  }

  GetPageRoute pageRouteBuilder({
    required Widget page,
    RouteSettings? settings,
  }) => GetPageRoute(
    transitionDuration: Duration.zero,
    page: () => page,
    settings: settings,
  );
}
