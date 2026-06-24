class AttendanceResponse {
  final bool success;
  final String message;

  AttendanceResponse({
    required this.success,
    required this.message,
  });

  factory AttendanceResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return AttendanceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}