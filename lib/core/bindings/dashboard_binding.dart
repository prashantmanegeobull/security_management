import 'package:get/get.dart';
import 'package:security_management/features/dashBoard/Controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    print("DashboardBinding Called");

    Get.lazyPut<DashboardController>(
          () => DashboardController(),
    );
  }
}