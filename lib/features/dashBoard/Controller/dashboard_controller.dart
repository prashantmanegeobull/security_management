import 'package:get/get.dart';

import '../../shared/active_shift_manager.dart';
import '../../shift/service/shift_service.dart';

class DashboardController extends GetxController {

  RxInt selectedIndex = 0.obs;

  RxString userName = "Ramesh".obs;
  RxString greeting = "Good Morning".obs;

  RxString shiftName = "Morning Shift".obs;
  RxString shiftTime = "8:00 AM - 8:00 PM".obs;
  RxString siteName = "Green Valley Society".obs;

  @override
  void onInit() {
    loadAssignedShift();
    super.onInit();
  }

  Future<void> loadAssignedShift() async {
    final service = ShiftService();

    final response = await service.getShifts();

    final currentShift = response["current"]?.first;

    if (currentShift != null) {
      Get.find<ActiveShiftManager>().set(currentShift);
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed('/dashBoard');
        break;

      case 1:
        Get.toNamed('/shifts');
        break;

      case 2:
        Get.toNamed('/attendance');
        break;

      case 3:
        Get.to(());
        break;
    }
  }
}