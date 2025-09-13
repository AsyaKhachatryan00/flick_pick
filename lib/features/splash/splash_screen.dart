import 'package:flick_pick/core/config/constants/app_assets.dart';
import 'package:flick_pick/core/config/constants/storage_keys.dart';
import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flick_pick/core/route/routes.dart';
import 'package:flick_pick/core/widgets/custom_button.dart';
import 'package:flick_pick/core/widgets/dialog_screen.dart';
import 'package:flick_pick/core/widgets/utils/shared_prefs.dart';
import 'package:flick_pick/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  RxBool startAnimations = false.obs;
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_opacityController)..addListener(updateUi);

    Future.delayed(const Duration(milliseconds: 500), () {
      startAnimations.value = true;
      _opacityController.forward();
    });

    _opacityController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(microseconds: 3000), () async {
          final isNotificationsOn = locator<SharedPrefs>().getBool(
            StorageKeys.isNotificationsOn,
          );
          if (!isNotificationsOn) {
            openNotDialog();
          }
        });
      }
    });
  }

  void updateUi() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _opacityAnimation.removeListener(updateUi);
    _opacityController.dispose();
  }

  void openNotDialog() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => DialogScreen(
        onTap: (value) => locator<SharedPrefs>().setBool(
          StorageKeys.isNotificationsOn,
          value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.macaroni, AppColors.tickleMePink],
          ),
        ),
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: 1 - _opacityAnimation.value,
              duration: Duration(milliseconds: 500),
              child: Center(
                child: Image.asset(
                  AppImages.splash,
                  width: 120.w,
                  height: 120.h,
                ),
              ),
            ),

            AnimatedOpacity(
              opacity: _opacityController.value,
              duration: Duration(milliseconds: 1000),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.bg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 51.w,
                      top: 260.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            'FlickPick\nReelRandom',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Create and manage your movie \ncollections with ease',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 42.h,
                      left: 16.w,
                      right: 16.w,
                      child: Row(
                        children: [
                          CustomButton(width: 143.w, data: 'Terms of Use'),
                          FloatingActionButton(
                            shape: CircleBorder(),
                            backgroundColor: AppColors.white,
                            onPressed: () => Get.offAllNamed(RouteLink.main),
                            child: Icon(
                              Icons.play_arrow,
                              color: AppColors.primary,
                            ),
                          ),
                          CustomButton(width: 143.w, data: 'Privacy Policy'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
