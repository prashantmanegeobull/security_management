import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:security_management/features/shift/screen/shift_details_screen.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../controller/shift_controller.dart';
import '../widget/shift_card.dart';

class ShiftScreen extends StatelessWidget {
  ShiftScreen({super.key});

  final controller =
  Get.find<ShiftController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:
        AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor:
          AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,

          title: Text(
            "My Shifts",
            style:
            AppTextStyles.title.copyWith(fontSize: 17),
          ),

          bottom: PreferredSize(
            preferredSize:
            const Size.fromHeight(52),
            child: Column(
              children: [
                TabBar(
                  labelColor:
                  AppColors.primary,
                  unselectedLabelColor:
                  AppColors.textSecondary,
                  indicatorColor:
                  AppColors.primary,
                  indicatorWeight: 2.5,
                  indicatorSize:
                  TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(
                      text: "Current",
                    ),
                    Tab(
                      text: "Upcoming",
                    ),
                  ],
                ),

                Container(
                  height: 1,
                  color:
                  AppColors.border,
                ),
              ],
            ),
          ),
        ),
        body: Obx(() {
          if (controller
              .isLoading.value) {
            return const Center(
              child:
              CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          return TabBarView(
            children: [
              ListView.separated(
                padding:
                const EdgeInsets.all(
                    16),
                itemCount: controller
                    .currentShifts.length,
                separatorBuilder:
                    (_, __) =>
                const SizedBox(
                  height: 16,
                ),
                itemBuilder:
                    (context, index) {
                  return InkWell(
                    borderRadius:
                    BorderRadius
                        .circular(
                      16,
                    ),
                    onTap: () {
                      Get.to(()=>ShiftDetailsScreen(shift: controller.currentShifts[index],));
                    },
                    child: ShiftCard(
                      shift: controller
                          .currentShifts[
                      index],
                    ),
                  );
                },
              ),

              Center(
                child: Text(
                  "No Upcoming Shifts",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}