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
  }
}