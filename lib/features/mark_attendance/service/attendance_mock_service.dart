import 'dart:developer';

import '../model/attendance_request.dart';
import '../model/attendance_response.dart';

class AttendanceMockService {



  Future<AttendanceResponse> submitAttendance({
    required AttendanceRequest request,
  }) async {

    try {

      // Simulate API Delay
      await Future.delayed(
        const Duration(seconds: 2),
      );

      // Log Request
      log(
        "Attendance Request => ${request.toJson()}",
        name: "ATTENDANCE_API",
      );

      // Validation

      if (request.selfiePath.isEmpty) {
        return AttendanceResponse(
          success: false,
          message: "Selfie is required",
        );
      }

      if (request.shiftId.isEmpty) {
        return AttendanceResponse(
          success: false,
          message: "Shift ID missing",
        );
      }

      if (request.latitude == 0 ||
          request.longitude == 0) {
        return AttendanceResponse(
          success: false,
          message: "Invalid location",
        );
      }

      // Mock Success Response

      return AttendanceResponse(
        success: true,
        message:
        "Attendance Marked Successfully",
      );

    } catch (e) {

      return AttendanceResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}