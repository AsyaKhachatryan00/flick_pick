import 'dart:ui';

import 'package:flick_pick/core/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({required this.onTap, super.key});

  final ValueChanged<bool> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: CupertinoAlertDialog(
          title: Text(
            '“FlickPick: ReelRandom” Would Like to Send You Push Notifications',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: false,
              onPressed: () {
                onTap.call(false);
                Get.back();
              },
              child: Text(
                'Don’t Allow',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                onTap.call(true);
                Get.back();
              },
              child: Text(
                'OK',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
