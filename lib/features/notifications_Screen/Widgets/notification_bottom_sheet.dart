import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

class NotificationBottomSheet {

  static void show({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),

        decoration: const BoxDecoration(
          color: AppColors.white,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Handle Bar

            Container(
              width: 50,
              height: 5,

              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius:
                BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 24),

            /// Icon

            Container(
              height: 70,
              width: 70,

              decoration: BoxDecoration(
                color: iconColor.withOpacity(.1),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: 35,
              ),
            ),

            const SizedBox(height: 20),

            /// Title

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.title,
            ),

            const SizedBox(height: 10),

            /// Message

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            /// Button

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },

                child: const Text(
                  "Got It",
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),

      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}