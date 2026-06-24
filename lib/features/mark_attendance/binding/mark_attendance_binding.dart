import 'package:get/get.dart';

import '../controller/mark_attendance_controller.dart';

class MarkAttendanceBinding
    extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut(
          () =>
          MarkAttendanceController(),
    );
  }
}