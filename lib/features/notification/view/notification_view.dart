import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../Widgets/notification_bottom_sheet.dart';
import '../controller/notification_controller.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() =>
      _NotificationViewState();
}

class _NotificationViewState
    extends State<NotificationView> {

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.scaffoldBg,

      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Notifications"),

        actions: [
          TextButton(
            onPressed: () {
              controller.markAllRead();
            },
            child: const Text("Mark All Read"),
          ),
        ],
      ),

      body: Column(
        children: [
          /// TOP CARD
          Container(
            margin:
            const EdgeInsets.all(16),
            padding:
            const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(18,
              ),
            ),

            child: Obx(
                  () => Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,

                    decoration:
                    const BoxDecoration(
                      color: AppColors.primary,
                      shape:BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.notifications_active,
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          "${controller.unreadCount} Unread Notifications",
                          style: AppTextStyles.bodyMedium,
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          "Stay updated with shifts, leaves and announcements.",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(
                  () => ListView.builder(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                itemCount: controller.notifications.length,

                itemBuilder: (context, index) {

                  final item =
                  controller.notifications[index];

                  return InkWell(

                    borderRadius:
                    BorderRadius.circular(18),

                    onTap: () {

                      controller.markAsRead(index);

                      NotificationBottomSheet.show(
                        title: item.title,
                        message: item.message,
                        icon: item.icon,
                        iconColor: item.color,
                      );

                    },

                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,),

                      padding: const EdgeInsets.all(14,),

                      decoration: BoxDecoration(
                        color: AppColors.cardBg,

                        borderRadius:
                        BorderRadius.circular(18),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(
                            height: 50,
                            width: 50,

                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.1),

                              borderRadius: BorderRadius.circular(14,
                              ),
                            ),

                            child: Icon(
                              item.icon,
                              color: item.color,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),

                                    if (item.isUnread)
                                      Container(
                                        height: 8,
                                        width: 8,
                                        decoration:
                                        const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  item.message,
                                  style: AppTextStyles.caption,
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(item.time,
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}