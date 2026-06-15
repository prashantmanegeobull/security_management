import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/model/shift_model.dart';

class ShiftCard extends StatelessWidget {
  final ShiftModel shift;

  const ShiftCard({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = shift.showBadge;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primaryLight
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent
                ? const Color(0xFFBFD4FF)
                : AppColors.border,
          ),
        boxShadow: isCurrent
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shift.shiftName,
                style:
                AppTextStyles.title.copyWith(
                  fontWeight:
                  FontWeight.w700,
                  fontSize: 15
                ),
              ),

              if (shift.showBadge)
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration:
                  BoxDecoration(
                    color: AppColors.success
                        .withOpacity(0.12),
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    shift.status,
                    style:
                    AppTextStyles.caption
                        .copyWith(
                      color:
                      AppColors.success,
                      fontWeight:
                      FontWeight.w600,
                      fontSize: 11
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "${shift.startTime} - ${shift.endTime}",
            style:
            AppTextStyles.bodyMedium,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Text(
                  shift.siteName,
                  style:
                  AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary
                  ),
                ),
              ),

              if (!shift.showBadge)
                Text(
                  shift.status,
                  style:
                  AppTextStyles.caption,
                ),
            ],
          ),
        ],
      ),
    );
  }
}