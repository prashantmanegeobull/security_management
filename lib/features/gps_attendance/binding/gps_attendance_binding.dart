import 'package:get/get.dart';

import '../controller/gps_attendance_controller.dart';

class GpsAttendanceBinding
    extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut(
          () =>
          GpsAttendanceController(),
      fenix: true,
    );
  }
}