import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.data,
    this.onTap,
    this.height,
    this.textColor,
    this.width,
    this.color,
    this.child,
    this.style,
  });

  final String? data;
  final void Function()? onTap;

  final double? height;
  final double? width;
  final Color? textColor;
  final Color? color;
  final Widget? child;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 343.w,
        height: height ?? 56.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? AppColors.red,
          borderRadius: BorderRadius.circular(46.r),
        ),
        child: data != null
            ? Text(
                data!,
                textAlign: TextAlign.center,
                style:
                    style ??
                    Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: textColor),
              )
            : child,
      ),
    );
  }
}
