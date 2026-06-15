import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Helper/ApiString.dart';
import '../model/dashboard_model.dart';
import '../model/leave_model.dart';



class DashboardRepository {

  Future<DashboardModel> getMonthlyAttendance({
    required String userId,
    required String adminId,
    required String appTypeId,
    required int month,
    required int year,
  }) async {

    try {

      ///  Run Attendance + Leave API in parallel
      final responses = await Future.wait([
        http.post(
          Uri.parse(ApiString.get_monthly_attendance),
          body: {
            "user_auto_id": userId,
            "admin_auto_id": adminId,
            "app_type_id": appTypeId,
            "month": month.toString(),
            "year": year.toString(),
          },
        ),
        getLeaveList(
          userId: userId,
          adminId: adminId,
          appTypeId: appTypeId,
        ),
      ]);

      final attendanceResponse = responses[0] as http.Response;
      final leaveList = responses[1] as List<LeaveModel>;

      final attendanceJson = jsonDecode(attendanceResponse.body);

      if (attendanceJson["status"] != 1) {
        throw Exception(attendanceJson["msg"]);
      }

      List list = attendanceJson["data"];

      List<AttendanceData> attendance =
      list.map((e) => AttendanceData.fromJson(e)).toList();

      ///  PARALLEL TASK API CALLS (BIG IMPROVEMENT)
      int daysInMonth = DateTime(year, month + 1, 0).day;

      List<Future<int>> taskFutures = [];

      for (int day = 1; day <= daysInMonth; day++) {

        String date =
            "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

        taskFutures.add(fetchTaskCount(
          userId: userId,
          adminId: adminId,
          appTypeId: appTypeId,
          date: date,
        ));
      }

      final taskResults = await Future.wait(taskFutures);
      int totalTask = taskResults.fold(0, (sum, item) => sum + item);

      ///  CALCULATIONS
      double totalDistance = 0;
      DashboardSummary summary = DashboardSummary();

      Duration totalDuration = Duration.zero;
      DateTime? lastLogin;

      final timeFormat1 = DateFormat("HH:mm");
      final timeFormat2 = DateFormat("HH:mm:ss");

      for (var item in attendance) {

        /// Distance
        totalDistance +=
            double.tryParse(item.distanceTravelled?.toString() ?? "0") ?? 0;

        /// Parse login time
        if (item.loginTime != null) {
          try {
            lastLogin = timeFormat1.parse(item.loginTime!);
          } catch (_) {
            try {
              lastLogin = timeFormat2.parse(item.loginTime!);
            } catch (_) {}
          }
        }

        /// Parse logout time
        if (item.logoutTime != null && lastLogin != null) {

          DateTime? logout;

          try {
            logout = timeFormat2.parse(item.logoutTime!);
          } catch (_) {
            try {
              logout = timeFormat1.parse(item.logoutTime!);
            } catch (_) {}
          }

          if (logout != null && logout.isAfter(lastLogin)) {
            totalDuration += logout.difference(lastLogin);
          }

          lastLogin = null;
        }

        /// Status Count
        switch (item.dayStatus) {
          case "Present":
            summary.present++;
            break;
          case "Absent":
            summary.absent++;
            break;
          case "Public Holiday":
            summary.publicHoliday++;
            break;
          case "Weekly Off":
            summary.weeklyOff++;
            break;
        }
      }

      /// LEAVE CALCULATION
      for (var leave in leaveList) {

        DateTime start = DateFormat("dd/MM/yyyy").parse(leave.startDate);

        if (start.month == month && start.year == year) {

          if (leave.status.toLowerCase() == "approved") {
            summary.leave++;
          }

          if (leave.status.toLowerCase() == "pending") {
            summary.pending++;
          }
        }
      }

      /// FORMAT TOTAL HOURS
      String totalHours =
          "${totalDuration.inHours.toString().padLeft(2, '0')}:"
          "${(totalDuration.inMinutes % 60).toString().padLeft(2, '0')}:"
          "${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}";

      return DashboardModel(
        data: attendance,
        summary: summary,
        totalTask: totalTask,
        totalDistance: totalDistance,
        totalHours: totalHours,
      );

    } catch (e) {
      throw Exception("Dashboard Error: $e");
    }
  }

  ///  SINGLE DAY TASK COUNT API
  Future<int> fetchTaskCount({
    required String userId,
    required String adminId,
    required String appTypeId,
    required String date,
  }) async {

    try {

      final response = await http.post(
        Uri.parse(ApiString.getTaskLists),
        body: {
          "user_auto_id": userId,
          "admin_auto_id": adminId,
          "app_type_id": appTypeId,
          "date": date,
        },
      );

      final json = jsonDecode(response.body);

      int count = 0;

      if (json["status"] == 1) {

        List data = json["data"] ?? [];

        for (var item in data) {
          List tasks = item["task_details"] ?? [];
          count += tasks.length;
        }
      }

      return count;

    } catch (_) {
      return 0;
    }
  }
}

///  LEAVE API
Future<List<LeaveModel>> getLeaveList({
  required String userId,
  required String adminId,
  required String appTypeId,
}) async {

  try {

    final response = await http.post(
      Uri.parse(ApiString.get_leave),
      body: {
        "user_auto_id": userId,
        "admin_auto_id": adminId,
        "app_type_id": appTypeId,
      },
    );

    final json = jsonDecode(response.body);

    if (json["status"] != 1) {
      return [];
    }

    List list = json["data"] ?? [];

    return list.map((e) => LeaveModel.fromJson(e)).toList();

  } catch (_) {
    return [];
  }
}