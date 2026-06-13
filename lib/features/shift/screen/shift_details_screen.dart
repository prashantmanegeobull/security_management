import 'package:flutter/material.dart';

import '../../../core/model/shift_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

class ShiftDetailScreen
    extends StatelessWidget {
  final ShiftModel shift;

  const ShiftDetailScreen({
    super.key,
    required this.shift,
  });

  Widget buildItem(
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            AppTextStyles.caption,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style:
            AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.white,
      appBar: AppBar(
        title: const Text(
          "Shift Details",
        ),
      ),
      body: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(
                18,
              ),
              decoration:
              BoxDecoration(
                color:
                AppColors.primary,
                borderRadius:
                BorderRadius
                    .circular(14),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    shift.shiftName,
                    style:
                    AppTextStyles
                        .title
                        .copyWith(
                      color: Colors
                          .white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${shift.startTime} - ${shift.endTime}",
                    style:
                    AppTextStyles
                        .bodyMedium
                        .copyWith(
                      color: Colors
                          .white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            buildItem(
              "Site Name",
              shift.siteName,
            ),

            const Divider(),

            buildItem(
              "Shift Start Time",
              shift.startTime,
            ),

            const Divider(),

            buildItem(
              "Shift End Time",
              shift.endTime,
            ),

            const Spacer(),

            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.navigation,
              ),
              label: const Text(
                "Navigate to Site",
              ),
            ),
          ],
        ),
      ),
    );
  }
}