import '../../core/model/shift_model.dart';
import '../Helper/shift_time_validator.dart';

class AttendanceRuleEngine {

  static bool canTriggerAttendance(ShiftModel shift, double distance) {
    return _isInsideRadius(shift, distance);
  }

  /// LOGIN RULE: inside radius + after shift start time
  static bool canSubmitAttendance(ShiftModel shift) {
    final timeOk = ShiftTimeValidator.canMarkAttendance(shift);
    return timeOk;
  }

  /// FUTURE USE: logout validation
  static bool canLogout(ShiftModel shift) {
    return ShiftTimeValidator.canLogout(shift);
  }

  static bool _isInsideRadius(ShiftModel shift, double distance) {
    return distance <= shift.siteRadius;
  }
}