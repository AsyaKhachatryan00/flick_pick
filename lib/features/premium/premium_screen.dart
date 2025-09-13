import 'package:flick_pick/core/config/constants/app_assets.dart';
import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flick_pick/core/widgets/custom_button.dart';
import 'package:flick_pick/features/main/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.isRegistered()
        ? Get.find<MainController>()
        : Get.put(MainController());

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.premium),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: AppColors.white),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 115.h),
                Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 23.h, 22.w, 131.h),
                  child: Text(
                    'We’re building FlickPick with love. \nYour small support keeps the magic alive!',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(fontSize: 32.sp),
                  ),
                ),

                CustomButton(
                  width: 327.w,
                  data: 'Donate \$0,49',
                  onTap: controller.setPremium,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: CustomButton(
                    width: 327.w,
                    data: 'Restore',
                    color: AppColors.white,
                    textColor: AppColors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
