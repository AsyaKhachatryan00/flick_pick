import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flick_pick/core/widgets/custom_button.dart';
import 'package:flick_pick/features/home/widgets/dashed_border.dart';
import 'package:flick_pick/features/main/controller/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MainController _controller;
  final FormGroup form = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'desc': FormControl<String>(validators: [Validators.required]),
    'genre': FormControl<String>(validators: [Validators.required]),
    'directors': FormControl<String>(validators: [Validators.required]),
  });

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
            child: ReactiveForm(
              formGroup: form,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back),
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(right: 24.w),
                      child: Text(
                        'Add New Movie',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  GetBuilder<MainController>(
                    builder: (controller) => InkWell(
                      onTap: showActionSheet,
                      child: SizedBox(
                        height: 217.h,
                        width: 192.w,
                        child: DashedGradientBorder(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.macaroni,
                              AppColors.tickleMePink,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          child: Container(
                            color: Colors.white.withValues(alpha: 0.38),
                            alignment: Alignment.center,
                            child: controller.filePath == null
                                ? Icon(
                                    Icons.image,
                                    color: AppColors.primary,
                                    size: 36,
                                  )
                                : Image.memory(
                                    controller.filePath!,
                                    fit: BoxFit.cover,
                                    height: 217.h,
                                    width: 192.w,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        ReactiveTextField(
                          formControlName: 'title',
                          showErrors: (control) => false,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(height: 1.3, color: AppColors.black),
                          decoration: _decoration('Title'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: ReactiveTextField(
                            formControlName: 'genre',
                            showErrors: (control) => false,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(height: 1.3, color: AppColors.black),
                            decoration: _decoration('Genre'),
                          ),
                        ),
                        ReactiveTextField(
                          formControlName: 'directors',
                          showErrors: (control) => false,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(height: 1.3, color: AppColors.black),
                          decoration: _decoration('Directors'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.38),
                            ),
                            height: 97.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: ReactiveTextField(
                              formControlName: 'desc',
                              maxLines: null,
                              showErrors: (control) => false,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    height: 1.3,
                                    color: AppColors.black,
                                  ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Description',
                                hintStyle: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      height: 1.3,
                                      color: Color(0xFF818181),
                                    ),
                              ),
                            ),
                          ),
                        ),

                        ReactiveFormConsumer(
                          builder: (context, formGroup, child) => Opacity(
                            opacity: formGroup.valid ? 1 : 0.5,
                            child: CustomButton(
                              data: 'Save',
                              onTap: () => formGroup.valid
                                  ? _controller.addMovie(form: formGroup)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      fillColor: AppColors.white.withValues(alpha: 0.38),
      filled: true,
      hintText: hint,
      hintStyle: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(height: 1.3, color: Color(0xFF818181)),
    );
  }

  void showActionSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(
          'Select source',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.blue),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              _controller.onFilePicked(ImageSource.camera);
              Get.back();
            },
            child: Text(
              'Camera',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.blue),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              _controller.onFilePicked(ImageSource.gallery);
              Get.back();
            },
            child: Text(
              'Photo Library',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.blue),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.blue),
          ),
        ),
      ),
    );
  }
}
