class LeaveModel {
  final String id;
  final String userAutoId;
  final String adminAutoId;
  final String appTypeId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String isHalfDay;
  final String reason;
  final String shift;
  final String status;
  final String weeklyLeave;

  LeaveModel({
    required this.id,
    required this.userAutoId,
    required this.adminAutoId,
    required this.appTypeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.isHalfDay,
    required this.reason,
    required this.shift,
    required this.status,
    required this.weeklyLeave,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['_id']?.toString() ?? '',
      userAutoId: json['user_auto_id']?.toString() ?? '',
      adminAutoId: json['admin_auto_id']?.toString() ?? '',
      appTypeId: json['app_type_id']?.toString() ?? '',
      leaveType: json['leave_type']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      isHalfDay: json['is_half_day']?.toString() ?? 'No',
      reason: json['reason']?.toString() ?? '',
      shift: json['shift']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      weeklyLeave: json['weekly_leave']?.toString() ?? 'No',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_auto_id': userAutoId,
      'admin_auto_id': adminAutoId,
      'app_type_id': appTypeId,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'is_half_day': isHalfDay,
      'reason': reason,
      'shift': shift,
      'status': status,
      'weekly_leave': weeklyLeave,
    };
  }
}