import 'dart:ui';

import 'package:flick_pick/core/config/constants/app_assets.dart';
import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flick_pick/features/main/widgets/movie_props_dialog.dart';
import 'package:flick_pick/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.scale,
    required this.isEditing,
    required this.opacity,
    this.index,
  });
  final Movie movie;
  final double scale;
  final double opacity;
  final RxBool isEditing;
  final int? index;
  final ValueChanged<Movie> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.bottomSheet(
        MoviePropsDialog(movie: movie),
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
      ),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: Container(
            height: 435.h,
            width: 265.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.macaroni, AppColors.tickleMePink],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              color: movie.poster == null ? AppColors.white : null,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Container(
              height: 435.h,
              width: 265.w,
              decoration: BoxDecoration(
                color: movie.poster == null ? AppColors.white : null,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  Positioned(
                    width: 250.w,
                    height: 435.h,
                    child: Container(
                      width: movie.poster == null ? 120.w : 265.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        image: DecorationImage(
                          image: movie.poster == null
                              ? AssetImage(AppImages.splash)
                              : MemoryImage(movie.poster!),
                          fit: movie.poster == null
                              ? BoxFit.contain
                              : BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    width: 249.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(8.r),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          width: 230.w,
                          height: 76.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(8.r),
                            ),
                            color: Color(0xFF191919).withValues(alpha: 0.82),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  movie.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ),

                              InkWell(
                                onTap: () => onTap(movie),
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  margin: EdgeInsets.only(right: 16.w),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 0.h,
                    left: 0.w,
                    child: Obx(() {
                      if (isEditing.value) {
                        return ReorderableDragStartListener(
                          index: index!,
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                bottomRight: Radius.circular(8.r),
                              ),
                            ),
                            child: Icon(
                              Icons.drag_indicator,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
