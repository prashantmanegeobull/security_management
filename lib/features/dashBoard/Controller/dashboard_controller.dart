import 'package:get/get.dart';

class DashboardController extends GetxController {

  RxInt selectedIndex = 0.obs;

  RxString userName = "Ramesh".obs;
  RxString greeting = "Good Morning".obs;

  RxString shiftName = "Morning Shift".obs;
  RxString shiftTime = "8:00 AM - 8:00 PM".obs;
  RxString siteName = "Green Valley Society".obs;

  void changeTab(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        Get.offAllNamed('/dashboard');
        break;

      case 1:
        Get.offAllNamed('/shifts');
        break;

      case 2:
        Get.offAllNamed('/attendance');
        break;

      case 3:
        Get.offAllNamed('/more');
        break;
    }
  }
}