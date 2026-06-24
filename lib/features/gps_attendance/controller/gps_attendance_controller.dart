import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../core/model/shift_model.dart';
import '../../../core/rules/attendance_rule_engine.dart';
import '../../shared/active_shift_manager.dart';
import '../service/attendance_sound_service.dart';
import '../service/gps_tracking_service.dart';
import '../widgets/attendance_alert_dialog.dart';

class GpsAttendanceController extends GetxController {

  final GpsService _gpsService = GpsService();

  StreamSubscription<Position>? _subscription;

  RxDouble distance = 0.0.obs;
  RxBool popupShown = false.obs;
  RxBool popupDismissed = false.obs;

  final ActiveShiftManager shiftManager = Get.find();

  Future<void> startTracking() async {

    final permission = await _gpsService.checkPermission();
    if (!permission) return;

    final gpsEnabled = await _gpsService.isGpsEnabled();
    if (!gpsEnabled) return;

    _subscription?.cancel();

    _subscription = _gpsService
        .getPositionStream()
        .listen(_onLocationUpdate);
  }

  void _onLocationUpdate(Position position) {

    final ShiftModel? shift = shiftManager.current;
    if (shift == null) return;

    final calculatedDistance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      shift.latitude,
      shift.longitude,
    );

    distance.value = calculatedDistance;

    final insideRadius =
        calculatedDistance <= shift.siteRadius;

    final canTrigger =
    AttendanceRuleEngine.canTriggerAttendance(
      shift,
      calculatedDistance,
    );

    /// Reset popup state when user leaves radius
    if (!insideRadius) {
      popupShown.value = false;
      popupDismissed.value = false;
      return;
    }

    /// Prevent repeated popup
    if (canTrigger &&
        !popupShown.value &&
        !popupDismissed.value) {

      popupShown.value = true;

      print("BEFORE PLAYING ATTENDANCE SOUND");
      AttendanceSoundService.playAttendanceAlert();
      print("AFTER PLAYING ATTENDANCE SOUND");

      Get.dialog(
        AttendanceAlertDialog(
          shift: shift,
          distance: calculatedDistance,
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}