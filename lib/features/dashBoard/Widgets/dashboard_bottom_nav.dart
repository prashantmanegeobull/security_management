import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashBoard/Controller/dashboard_controller.dart' show DashboardController;


class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key});

  @override
  Widget build(BuildContext context) {

    final DashboardController controller =
    Get.find<DashboardController>();

    return Obx(
          () => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        type: BottomNavigationBarType.fixed,

        onTap: controller.changeTab,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "Shifts",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Attendance",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "More",
          ),
        ],
      ),
    );
  }
}