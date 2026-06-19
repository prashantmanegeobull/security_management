import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
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

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {},

              icon: const Icon(
                Icons.map_outlined,
                size: 20,
                color: Colors.white,
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
                AppColors.primaryDark,

                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    12,
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