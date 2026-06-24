class AttendanceRequest {
  final String shiftId;
  final String siteCode;
  final double latitude;
  final double longitude;
  final double distance;
  final String attendanceTime;
  final String selfiePath;

  AttendanceRequest({
    required this.shiftId,
    required this.siteCode,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.attendanceTime,
    required this.selfiePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'shift_id': shiftId,
      'site_code': siteCode,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'attendance_time': attendanceTime,
      'selfie_path': selfiePath,
    };
  }
}