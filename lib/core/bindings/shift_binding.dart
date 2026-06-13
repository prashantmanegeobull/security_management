import 'package:get/get.dart';

import '../../features/shift/controller/shift_controller.dart';


class ShiftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ShiftController(),
    );
  }
}