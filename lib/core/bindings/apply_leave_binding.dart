import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../features/ApplyLeaves/controller/apply_leave_controller.dart';
import '../../features/my_leaves/controller/leave_controller.dart';

class ApplyLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplyLeaveController>(
          () => ApplyLeaveController(),
    );
  }
}