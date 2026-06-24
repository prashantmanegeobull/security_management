import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/rules/attendance_rule_engine.dart';
import '../../shared/active_shift_manager.dart';
import '../model/attendance_request.dart';
import '../service/attendance_mock_service.dart';

class MarkAttendanceController extends GetxController {

  Rx<File?> selfieFile = Rx<File?>(null);
  RxBool isSubmitting = false.obs;

  final ImagePicker _picker = ImagePicker();

  final ActiveShiftManager shiftManager = Get.find();
  final AttendanceMockService service = AttendanceMockService();

  Future<void> captureSelfie() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 70,
    );

    if (image != null) {
      selfieFile.value = File(image.path);
    }
  }

  Future<void> submitAttendance() async {

    final shift = shiftManager.current;

    if (shift == null) {
      Get.snackbar("Error", "No active shift");
      return;
    }

    if (!AttendanceRuleEngine.canSubmitAttendance(shift)) {
      Get.snackbar(
        "Not Allowed",
        "You cannot mark attendance before shift start time",
      );
      return;
    }

    if (selfieFile.value == null) {
      Get.snackbar("Required", "Please capture selfie");
      return;
    }

    isSubmitting.value = true;

    try {
      final request = AttendanceRequest(
        shiftId: shift.id,
        siteCode: shift.siteCode,
        latitude: shift.latitude,
        longitude: shift.longitude,
        distance: 0,
        attendanceTime: DateTime.now().toIso8601String(),
        selfiePath: selfieFile.value!.path,
      );

      final response = await service.submitAttendance(
        request: request,
      );

      if (response.success) {
        Get.back();
        Get.snackbar("Success", response.message);
      } else {
        Get.snackbar("Failed", response.message);
      }

    } finally {
      isSubmitting.value = false;
    }
  }
}