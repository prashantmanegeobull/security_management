class LeaveTypesResponse {
  final int status;
  final String msg;
  final int totalLeave;
  final int remainingYearlyLeave;
  final int weeklyLeave;
  final List<LeaveTypeData> data;

  LeaveTypesResponse({
    required this.status,
    required this.msg,
    required this.totalLeave,
    required this.remainingYearlyLeave,
    required this.weeklyLeave,
    required this.data,
  });

  factory LeaveTypesResponse.fromJson(Map<String, dynamic> json) {
    return LeaveTypesResponse(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? '',
      totalLeave: json['total_leave'] ?? 0,
      remainingYearlyLeave: json['remaining_yearly_leave'] ?? 0,
      weeklyLeave: json['weekly_leave'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => LeaveTypeData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'total_leave': totalLeave,
      'remaining_yearly_leave': remainingYearlyLeave,
      'weekly_leave': weeklyLeave,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveTypeData {
  final String id;
  final String leaveType;
  final int leavesCount;

  LeaveTypeData({
    required this.id,
    required this.leaveType,
    required this.leavesCount,
  });

  factory LeaveTypeData.fromJson(Map<String, dynamic> json) {
    return LeaveTypeData(
      id: json['_id'] ?? '',
      leaveType: json['leave_type'] ?? '',
      leavesCount: json['leaves_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'leave_type': leaveType,
      'leaves_count': leavesCount,
    };
  }
}