import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../Controller/dashboard_controller.dart';
import '../Widgets/dashboard_bottom_nav.dart';
import '../Widgets/service_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller =
  Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    controller.selectedIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                        'assets/images/profile.png',
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Obx(
                            () => Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${controller.userName.value}",
                              style: AppTextStyles.h3,
                            ),
                            Text(
                              controller.greeting.value,
                              style: AppTextStyles.subtitle,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// SHIFT CARD
              Obx(
                    () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1565C0),
                        Color(0xFF42A5F5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Shift",
                        style: AppTextStyles.subtitle.copyWith(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        controller.shiftName.value,
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            controller.shiftTime.value,
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              controller.siteName.value,
                              style: AppTextStyles.body.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize:
                          const Size(120, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Shift Started",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ATTENDANCE CARD
              Text(
                "Quick Actions",
                style: AppTextStyles.title,
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lllightgreen,
                  borderRadius:
                  BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10),
                        Text("Logged In"),
                        Spacer(),
                        Text("08:05 AM"),
                      ],
                    ),

                    SizedBox(height: 15),

                    Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10),
                        Text("At Site Location"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Services",
                style: AppTextStyles.title,
              ),

              const SizedBox(height: 16),

              /// ACTION GRID
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.15,
                children: [
                  ServiceCard(
                    icon: Icons.work_outline,
                    title: "My Shifts",
                    color: const Color(0xFF1565C0),
                    route: '/shifts',
                  ),
                  ServiceCard(
                    icon: Icons.check_circle_outline,
                    title: "Attendance",
                    color: const Color(0xFF2E7D32),
                    route: '/attendance',
                  ),
                  ServiceCard(
                    icon: Icons.note_alt_outlined,
                    title: "Apply Leave",
                    color: const Color(0xFFF57C00),
                    route: '/leave',
                  ),
                  ServiceCard(
                    icon: Icons.location_on_outlined,
                    title: "My Sites",
                    color: const Color(0xFF6A1B9A),
                    route: '/sites',
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar:
      const DashboardBottomNav(),
    );
  }

  Widget _actionCard(
      IconData icon,
      String title,
      String route,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Get.toNamed(route),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor:
              AppColors.primary.withOpacity(0.1),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 11),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}