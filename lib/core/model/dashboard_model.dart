class DashboardModel {

  final List<AttendanceData> data;
  final DashboardSummary summary;
  final int totalTask;
  final double totalDistance;
  final String totalHours;

  DashboardModel({
    required this.data,
    required this.summary,
    required this.totalTask,
    required this.totalDistance,
    required this.totalHours,
  });

  factory DashboardModel.fromJson(
      Map<String, dynamic> json,
      int monthlyTaskCount,
      ) {

    return DashboardModel(
      data: (json['data'] as List? ?? [])
          .map((e) => AttendanceData.fromJson(e))
          .toList(),

      summary: DashboardSummary(
        present: json['summary']?['present'] ?? 0,
        absent: json['summary']?['absent'] ?? 0,
        leave: json['summary']?['leave'] ?? 0,
        publicHoliday: json['summary']?['public_holiday'] ?? 0,
        pending: json['summary']?['pending'] ?? 0,
        weeklyOff: json['summary']?['weekly_off'] ?? 0,
      ),

      totalTask: monthlyTaskCount,
      totalDistance:
      double.tryParse(json['total_distance'].toString()) ?? 0,

      totalHours: json['total_hours'] ?? "00:00:00",
    );
  }
}

class AttendanceData {
  final String? loginTime;
  final String? logoutTime;
  final String? distanceTravelled;
  final String? dayStatus;
  final int? taskCount;
  final DateTime date;

  AttendanceData({
    this.loginTime,
    this.logoutTime,
    this.distanceTravelled,
    this.dayStatus,
    this.taskCount,
    required this.date,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      loginTime: json['login_time'],
      logoutTime: json['logout_time'],
      distanceTravelled: json['distance_travelled'],
      dayStatus: json['day_status'],
      taskCount: json['task_count'] == null
          ? 0
          : int.tryParse(json['task_count'].toString()),
      date: DateTime.parse(json['date']),
    );
  }
}

class DashboardSummary {
  int present;
  int absent;
  int leave;
  int publicHoliday;
  int pending;
  int weeklyOff;

  DashboardSummary({
    this.present = 0,
    this.absent = 0,
    this.leave = 0,
    this.publicHoliday = 0,
    this.pending = 0,
    this.weeklyOff = 0,
  });
}