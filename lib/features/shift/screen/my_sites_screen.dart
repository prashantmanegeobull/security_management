import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../controller/shift_controller.dart';
import '../widget/site_card.dart';

class MySitesScreen extends StatelessWidget {
  MySitesScreen({super.key});

  final ShiftController controller =
  Get.find<ShiftController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: const Text(
          "My Sites",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Obx(
            () {
              if (controller
                  .isLoading.value) {
                return const Center(
                  child:
                  CircularProgressIndicator(),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),

                itemCount:
                controller.currentShifts.length,

                separatorBuilder: (_, __) =>
                const SizedBox(height: 18),

                itemBuilder: (context, index) {
                  final site =
                  controller.currentShifts[index];

                  return SiteCard(
                    siteCode: site.siteCode,
                    siteName: site.siteName,
                    siteAddress: site.siteAddress,
                  );
                },
              );

            }),

      bottomNavigationBar: _buildNavigateButton(),
    );
  }

  Widget _buildNavigateButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding:
        const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              /// Open Google Maps
            },

            icon: const Icon(
              Icons.near_me_outlined,
              color:
              AppColors.primary,
              size: 22,
            ),

            label: Text(
              "Navigate to Site",
              style: AppTextStyles
                  .bodyMedium
                  .copyWith(
                color:
                AppColors.primary,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            style:
            OutlinedButton.styleFrom(
              backgroundColor:
              AppColors.primaryLight,

              side: const BorderSide(
                color:
                AppColors.primary,
                width: 1.3,
              ),

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius
                    .circular(
                  14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}