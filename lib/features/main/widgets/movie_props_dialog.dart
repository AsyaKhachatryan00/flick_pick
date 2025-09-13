import 'package:flick_pick/core/config/constants/app_assets.dart';
import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flick_pick/core/widgets/custom_button.dart';
import 'package:flick_pick/features/main/controller/main_controller.dart';
import 'package:flick_pick/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MoviePropsDialog extends StatelessWidget {
  const MoviePropsDialog({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 376.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46.w,
            height: 3.h,
            margin: EdgeInsets.only(top: 16.h, bottom: 32.h),
            decoration: BoxDecoration(
              color: Color(0xFF808080),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(
                          top: 4.h,
                          bottom: 16.h,
                        ),
                        child: Text(
                          movie.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      Text(
                        'Genre',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(
                          top: 4.h,
                          bottom: 16.h,
                        ),
                        child: Text(
                          movie.genre,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      Text(
                        'Directors',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(
                          top: 4.h,
                          bottom: 16.h,
                        ),
                        child: Text(
                          movie.directors,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: 171.w,
                      height: 179.h,
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        gradient: movie.poster == null
                            ? LinearGradient(
                                colors: [
                                  AppColors.macaroni.withValues(alpha: 0.3),
                                  AppColors.tickleMePink.withValues(alpha: 0.3),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                      ),
                      child: movie.poster != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.memory(
                                movie.poster!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 53.w,
                              height: 53.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppColors.white,
                              ),
                              child: Image.asset(
                                AppImages.splash,
                                width: 53.w,
                                height: 53.h,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: GetBuilder<MainController>(
                        builder: (controller) => Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.r),
                            color: movie.watched
                                ? AppColors.green
                                : AppColors.orange,
                          ),
                          child: Text(
                            movie.watched ? 'watched' : 'not watched',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(height: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.only(left: 16.w),
            margin: EdgeInsets.only(bottom: 4.h),
            alignment: Alignment.centerLeft,
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16.w),
            margin: EdgeInsets.only(bottom: 32.39.h),
            alignment: Alignment.centerLeft,
            child: Text(
              movie.desc,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.black),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    alignment: Alignment.center,
                    height: 56.h,
                    width: 76.w,
                    child: Text(
                      'Close',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: AppColors.red),
                    ),
                  ),
                ),
                GetBuilder<MainController>(
                  builder: (controller) => CustomButton(
                    width: 251.w,
                    onTap: () => controller.updateWatched(movie),
                    data: movie.watched ? 'Mark Unwatched' : 'Mark Watched',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
