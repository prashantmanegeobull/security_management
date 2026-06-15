import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_style.dart';
import '../controller/shift_controller.dart';
import '../my_theme/app_colors.dart';
import '../widget/site_card.dart';

class MySitesScreen extends StatelessWidget {
  MySitesScreen({super.key});

  final ShiftController controller =
  Get.find<ShiftController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: const Text(
          "My Sites",
          style: AppTextStyles.title,
        ),
      ),

      body: Obx(
            () => ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            24,
          ),
          itemCount:
          controller.currentShifts.length,
          separatorBuilder: (_, __) =>
          const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final site =
            controller.currentShifts[index];

            return SiteCard(
              siteCode: site.siteCode,
              siteName: site.siteName,
              siteAddress: site.siteAddress,
              isActive: site.isActive,
            );
          },
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20,
          ),
          child: SizedBox(
            height: 58,
            child: ElevatedButton.icon(
              onPressed: () {},

              icon: const Icon(
                Icons.map_rounded,
                size: 20,
              ),

              label: const Text(
                "View All Sites on Map",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppColors.primary,
                foregroundColor:
                AppColors.white,
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}