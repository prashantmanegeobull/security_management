import 'package:flutter/material.dart';

import '../my_theme/app_colors.dart';


class SiteCard extends StatelessWidget {
  final String siteCode;
  final String siteName;
  final String siteAddress;
  final bool isActive;

  const SiteCard({
    super.key,
    required this.siteCode,
    required this.siteName,
    required this.siteAddress,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final String letter =
    siteCode.replaceAll("Site ", "");

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.cardBg,

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.04,
            ),
            blurRadius: 20,
            offset: const Offset(
              0,
              6,
            ),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color:
              AppColors.primaryLight,
              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),

            alignment: Alignment.center,

            child: Text(
              letter,
              style: const TextStyle(
                color:
                AppColors.primaryDark,
                fontWeight:
                FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        siteCode,
                        style:
                        const TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight
                              .w700,
                          color: AppColors
                              .textPrimary,
                        ),
                      ),
                    ),

                    if (isActive)
                      Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration:
                        BoxDecoration(
                          color: AppColors
                              .successBg,
                          borderRadius:
                          BorderRadius
                              .circular(
                            30,
                          ),
                        ),
                        child:
                        const Text(
                          "Active",
                          style:
                          TextStyle(
                            color:
                            AppColors
                                .success,
                            fontSize:
                            12,
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  siteName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w500,
                    color: AppColors
                        .textSecondary,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  siteAddress,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontWeight:
                    FontWeight.w400,
                    color: AppColors
                        .textPrimary,
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