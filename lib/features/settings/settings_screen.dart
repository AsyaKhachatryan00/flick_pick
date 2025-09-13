import 'package:flick_pick/core/config/constants/app_assets.dart';
import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flick_pick/core/route/routes.dart';
import 'package:flick_pick/features/main/controller/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late MainController _controller;
  RxBool get _isNotsOn => _controller.isNotsOn;
  RxBool get _isPremium => _controller.isPremium;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<MainController>()) {
      _controller = Get.find<MainController>();
    } else {
      _controller = Get.put(MainController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.macaroni.withValues(alpha: 0.3),
              AppColors.tickleMePink.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            stops: const [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back, color: AppColors.black),
                    ),
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(width: 50.w),
                  ],
                ),
                SizedBox(height: 32.h),
                Obx(() => _premiumDecoration()),
                SizedBox(height: 8.h),
                Obx(
                  () => _decoration(
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(fontSize: 16.sp, height: 24 / 16),
                      ),
                      trailing: CupertinoSwitch(
                        value: _isNotsOn.value,
                        onChanged: (value) => _controller.setNots(value),
                      ),
                    ),
                  ),
                ),
                _decoration(
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Privacy Policy',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(fontSize: 16.sp, height: 24 / 16),
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                _decoration(
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,

                    title: Text(
                      'Terms of Use',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(fontSize: 16.sp, height: 24 / 16),
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _premiumDecoration() => InkWell(
    onTap: () => _isPremium.value ? null : Get.toNamed(RouteLink.premium),

    child: CustomPaint(
      painter: GradientBorderPainter(),
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: _isPremium.value ? Colors.transparent : AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isPremium.value
                  ? 'Thanks for support!'.toUpperCase()
                  : 'Support Us'.toUpperCase(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 16.sp,
                height: 24 / 16,
                color: !_isPremium.value ? AppColors.white : AppColors.primary,
              ),
            ),
            SvgPicture.asset(
              _isPremium.value ? AppSvgs.premium : AppSvgs.settings,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _decoration(Widget child) => Container(
    height: 64.h,
    alignment: Alignment.center,
    margin: EdgeInsets.only(bottom: 8.h),
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      color: AppColors.white.withValues(alpha: 0.3),
    ),
    child: child,
  );
}

class GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [AppColors.macaroni, AppColors.tickleMePink],

      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
