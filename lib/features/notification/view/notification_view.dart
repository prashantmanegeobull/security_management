import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/model/notification_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../Widgets/notification_bottom_sheet.dart';
import '../controller/notification_controller.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController controller =
  Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 56,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _RoundIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Get.back(),
          ),
        ),

        title: Text("Notifications", style: AppTextStyles.title),

        actions: [
          Obx(() {
            final bool hasUnread = controller.unreadCount > 0;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: hasUnread ? controller.markAllRead : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                icon: Icon(
                  Icons.done_all_rounded,
                  size: 18,
                  color: hasUnread ? AppColors.primary : AppColors.textHint,
                ),
                label: Text(
                  "Mark all read",
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                    hasUnread ? AppColors.primary : AppColors.textHint,
                  ),
                ),
              ),
            );
          }),
        ],
      ),

      body: Column(
        children: [
          /// TOP SUMMARY CARD
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Obx(
                  () => _SummaryCard(unreadCount: controller.unreadCount),
            ),
          ),

          Expanded(
            child: Obx(() {
              final items = controller.notifications;

              if (items.isEmpty) {
                return const _EmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return _NotificationTile(
                    item: item,
                    onTap: () {
                      controller.markAsRead(index);

                      NotificationBottomSheet.show(
                        title: item.title,
                        message: item.message,
                        icon: item.icon,
                        iconColor: item.color,
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Circular icon button used for the back action in the app bar.
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 38,
          width: 38,
          child: Icon(icon, size: 17, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// Gradient hero card summarizing unread notifications.
class _SummaryCard extends StatelessWidget {
  final int unreadCount;

  const _SummaryCard({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.lllightgreen],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unreadCount > 0
                      ? "$unreadCount Unread Notifications"
                      : "You're all caught up",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Stay updated with shifts, leaves and announcements.",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),

          if (unreadCount > 0) ...[
            const SizedBox(width: 10),
            Container(
              height: 32,
              width: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount > 9 ? "9+" : "$unreadCount",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A single notification row.
class _NotificationTile extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onTap;

  const _NotificationTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = item.isUnread;

    final Color borderColor = isUnread
        ? AppColors.primary.withOpacity(0.15)
        : AppColors.border.withOpacity(0.6);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
          decoration: BoxDecoration(
            color: isUnread
                ? AppColors.primaryLight.withOpacity(0.6)
                : AppColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(item.icon, color: item.color, size: 21),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isUnread
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.time,
                          style:
                          AppTextStyles.caption.copyWith(fontSize: 11),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),

              if (isUnread)
                Container(
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown when there are no notifications to display.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 84,
              width: 84,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_rounded,
                color: AppColors.primary.withOpacity(0.5),
                size: 36,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "You're all caught up",
              textAlign: TextAlign.center,
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 6),
            Text(
              "New notifications about shifts, leaves and announcements will show up here.",
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}