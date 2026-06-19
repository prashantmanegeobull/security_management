import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/model/notification_model.dart';
import '../../../core/theme/app_colors.dart';

class NotificationController extends GetxController {

  RxList<NotificationModel> notifications =
      <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.assignAll([
      NotificationModel(
        icon: Icons.assignment_ind_rounded,
        color: AppColors.primary,
        title: "New Shift Assigned",
        message:
        "You have been assigned to Site B - Silver Heights.",
        time: "10:30 AM",
        isUnread: true,
      ),

      NotificationModel(
        icon: Icons.schedule_rounded,
        color: Colors.indigo,
        title: "Shift Timing Changed",
        message:
        "Your shift timing for tomorrow has been updated.",
        time: "Yesterday",
        isUnread: true,
      ),

      NotificationModel(
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
        title: "Leave Approved",
        message:
        "Your leave request has been approved.",
        time: "2 May",
      ),

      NotificationModel(
        icon: Icons.cancel_rounded,
        color: AppColors.error,
        title: "Leave Rejected",
        message:
        "Your leave request has been rejected.",
        time: "1 May",
      ),

      NotificationModel(
        icon: Icons.campaign_rounded,
        color: AppColors.warning,
        title: "General Announcement",
        message:
        "Security meeting today at 5:00 PM.",
        time: "29 Apr",
      ),
    ]);
  }

  int get unreadCount =>
      notifications
          .where((e) => e.isUnread)
          .length;

  void markAsRead(int index) {
    if (notifications[index].isUnread) {
      notifications[index].isUnread = false;

      notifications.refresh();
    }
  }
  void markAllRead() {

    for (var item in notifications) {
      item.isUnread = false;
    }

    notifications.refresh();
  }
}