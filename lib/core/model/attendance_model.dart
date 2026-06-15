class AttendanceResponse {
  final int status;
  final String msg;
  final List<AttendanceModel> data;

  AttendanceResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? "",
      data: (json['data'] as List?)
          ?.map((e) => AttendanceModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class AttendanceModel {
  final String id;
  final String userAutoId;
  final String? loginTime;
  final String? logoutTime;
  final String? distanceTravelled;
  final String dayStatus;
  final String? taskCount;
  final DateTime createdAt;
  final DateTime? date;

  AttendanceModel({
    required this.id,
    required this.userAutoId,
    required this.dayStatus,
    required this.createdAt,
    this.loginTime,
    this.logoutTime,
    this.distanceTravelled,
    this.taskCount,
    this.date,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['_id'] ?? "",
      userAutoId: json['user_auto_id'] ?? "",
      loginTime: json['login_time'],
      logoutTime: json['logout_time'],
      distanceTravelled: json['distance_travelled'],
      dayStatus: json['day_status'] ?? "",
      taskCount: json['task_count']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}