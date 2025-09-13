import 'dart:math';

import 'package:flick_pick/core/config/constants/app_assets.dart';
import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flick_pick/core/route/routes.dart';
import 'package:flick_pick/core/widgets/custom_button.dart';
import 'package:flick_pick/features/main/controller/main_controller.dart';
import 'package:flick_pick/features/main/widgets/movie_card_list.dart';
import 'package:flick_pick/features/main/widgets/movie_props_dialog.dart';
import 'package:flick_pick/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainController _controller;

  final RxBool _isEditMode = false.obs;

  RxList<Movie> get movies => _controller.movies;

  int? draggingIndex;
  Offset dragOffset = Offset.zero;
  double dragRotation = 0.0;

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
          child: Column(
            children: [
              AppBar(
                leadingWidth: 0,
                backgroundColor: Colors.transparent,
                centerTitle: false,
                actionsPadding: EdgeInsets.only(right: 24.w),
                title: Padding(
                  padding: EdgeInsets.only(right: 24.w),
                  child: Text(
                    'Your Movie Deck ',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                actions: [
                  Obx(
                    () => InkWell(
                      onTap: () => _isEditMode.value = !_isEditMode.value,
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        padding: EdgeInsets.all(4.w),
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: _isEditMode.value ? AppColors.primary : null,
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: SvgPicture.asset(
                          AppSvgs.drag,
                          colorFilter: ColorFilter.mode(
                            _isEditMode.value
                                ? AppColors.white
                                : AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () => Get.toNamed(RouteLink.settings),
                    child: Container(
                      height: 32.h,
                      width: 32.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Icon(Icons.settings, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 52.h),
              Expanded(
                child: GetBuilder<MainController>(
                  builder: (c) => MovieCardList(
                    movies: movies,
                    isEditing: _isEditMode,
                    onTap: c.updateWatched,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex--;
                      setState(() {
                        final m = movies.removeAt(oldIndex);
                        movies.insert(newIndex, m);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              FloatingActionButton(
                shape: CircleBorder(),
                backgroundColor: AppColors.white,
                onPressed: () => Get.toNamed(RouteLink.home),
                child: Icon(Icons.add, color: AppColors.primary),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    CustomButton(
                      width: 171.5.w,
                      onTap: () {
                        setState(() => movies.shuffle());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppSvgs.shuffle),
                          SizedBox(width: 8.w),
                          Text(
                            'Shuffle',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      width: 171.5.w,
                      data: 'Random Movie',
                      onTap: () {
                        if (movies.isEmpty) return;
                        final random = Random();
                        final index = random.nextInt(movies.length);
                        final item = movies[index];

                        Get.bottomSheet(
                          MoviePropsDialog(movie: item),
                          isDismissible: false,
                          isScrollControlled: true,
                          enableDrag: false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
