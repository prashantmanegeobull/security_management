import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Helper/ApiString.dart';
import '../model/attendance_model.dart';

class AttendanceRepository {

  Future<List<AttendanceModel>> getMonthlyAttendance({
    required String userId,
    required String adminId,
    required String appTypeId,
    required String month,
    required String year,
  }) async {

    final url = Uri.parse(ApiString.get_monthly_attendance);

    final body = {
      "user_auto_id": userId,
      "admin_auto_id": adminId,
      "app_type_id": appTypeId,
      "month": month,
      "year": year,
    };

     print("API URL: $url");

     print("Request Body: $body");

    final response = await http.post(
      url,
      body: body,
    );

     print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final jsonData = jsonDecode(response.body);

    AttendanceResponse res = AttendanceResponse.fromJson(jsonData);

    return res.data;
  }


  Future<List<AttendanceModel>> getAttendance({
    required String userId,
    required String adminId,
    required String appTypeId,
    required String date,
  }) async {

    final url = Uri.parse(ApiString.get_attendance);

    final body = {
      "user_auto_id": userId,
      "admin_auto_id": adminId,
      "app_type_id": appTypeId,
      "date": date,
    };

     print("Attendance API URL: $url");

     print("Attendance Request Body: $body");

    final response = await http.post(
      url,
      body: body,
    );

     print("Attendance Status Code: ${response.statusCode}");
    print("Attendance Response: ${response.body}");

    final jsonData = jsonDecode(response.body);

    AttendanceResponse res = AttendanceResponse.fromJson(jsonData);

    return res.data;
  }
}