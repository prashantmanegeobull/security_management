import 'dart:convert';
import 'package:http/http.dart' as http;


import '../../features/Leave/leave_response_model.dart';
import '../Helper/ApiString.dart';




class LeaveRepository {


  Future<LeaveResponse> getLeaves({
    required String userAutoId,
    required String adminAutoId,
    required String appTypeId,
  }) async {
    final response = await http.post(
      Uri.parse(ApiString.get_leave),
      body: {
        'user_auto_id': userAutoId,
        'admin_auto_id': adminAutoId,
        'app_type_id': appTypeId,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server error: ${response.statusCode}");
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 1) {
      return LeaveResponse.fromJson(jsonData);
    } else {
      throw Exception(jsonData['msg']);
    }
  }


  Future<String> applyLeave({
    required String userAutoId,
    required String adminAutoId,
    required String appTypeId,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String isHalfDay,
    required String shift,
    required String reason,
    required String weeklyLeave,
  }) async {
    final response = await http.post(
      Uri.parse(ApiString.apply_leave),
      body: {
        'user_auto_id': userAutoId,
        'admin_auto_id': adminAutoId,
        'app_type_id': appTypeId,
        'leave_type': leaveType,
        'start_date': startDate,
        'end_date': endDate,
        'is_half_day': isHalfDay,
        'shift': shift,
        'reason': reason,
        'weekly_leave': weeklyLeave,
      },
    );
    print("APPLY BODY: ${{
      'user_auto_id': userAutoId,
      'admin_auto_id': adminAutoId,
      'app_type_id': appTypeId,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'is_half_day': isHalfDay,
      'shift': shift,
      'reason': reason,
      'weekly_leave': weeklyLeave,
    }}");

    print("STATUS: ${response.statusCode}");
    print("RESPONSE: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Server error: ${response.statusCode}");
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 1) {
      return jsonData['msg'];
    } else {
      throw Exception(jsonData['msg']);
    }
  }
}