import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SiteCard extends StatelessWidget {
  final String siteCode;
  final String siteName;
  final String siteAddress;

  const SiteCard({super.key,
    required this.siteCode,
    required this.siteName,
    required this.siteAddress,
  });

  @override
  Widget build(BuildContext context) {
    final String letter =
    siteCode.replaceAll("Site ", "");

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius:
        BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color:
              const Color(0xFFEFF4FF),

              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),

            alignment: Alignment.center,

            child: Text(
              letter,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight:
                FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      siteCode,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "Active",
                      style: TextStyle(
                        color:
                        AppColors.success,
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  siteName,
                  style: TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  siteAddress
                      .replaceAll(
                    " - 560001",
                    "",
                  )
                      .replaceAll(
                    " - 560002",
                    "",
                  )
                      .replaceAll(
                    " - 560025",
                    "",
                  ),
                  style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}