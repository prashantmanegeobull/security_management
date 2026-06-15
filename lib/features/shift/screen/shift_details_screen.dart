import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/model/shift_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

class ShiftDetailsScreen extends StatelessWidget {
  final ShiftModel shift;

  const ShiftDetailsScreen({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        title: const Text(
          "Shift Details",
          style:
          AppTextStyles.title,

        ),
        centerTitle: false,
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildHeaderCard(),

                  const SizedBox(height: 24),

                  _buildInfoTile(
                    title: "Site Name",
                    value:
                    "${shift.siteCode} - ${shift.siteName}",
                  ),

                  _buildInfoTile(
                    title: "Site Address",
                    value: shift.siteAddress,
                  ),

                  _buildInfoTile(
                    title:
                    "Shift Start Time",
                    value:
                    shift.startTime,
                  ),

                  _buildInfoTile(
                    title:
                    "Shift End Time",
                    value:
                    shift.endTime,
                  ),

                  _buildInfoTile(
                    title: "Site Radius",
                    value:
                    shift.siteRadius,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),

          _buildNavigateButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            shift.shiftName,
            style: AppTextStyles.title
                .copyWith(
              color: AppColors.white,
              fontWeight:
              FontWeight.w700,
              fontSize: 15
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "${shift.startTime} - ${shift.endTime}",
            style:
            AppTextStyles.bodyMedium
                .copyWith(
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            shift.shiftDate,
            style:
            AppTextStyles.body
                .copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(
            vertical: 18,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      title,
                      style:
                      AppTextStyles
                          .caption,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      value,
                      style:
                      AppTextStyles
                          .bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          const Divider(
            height: 1,
            color:
            AppColors.border,
          ),
      ],
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
          height: 42,
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
                FontWeight.w600,
              ),
            ),

            style:
            OutlinedButton.styleFrom(
              backgroundColor:
              AppColors.white,

              side: const BorderSide(
                color:
                AppColors.primary,
                width: 1.2,
              ),

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius
                    .circular(
                  12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}