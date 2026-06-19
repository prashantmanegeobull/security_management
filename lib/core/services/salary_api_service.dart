import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Helper/ApiString.dart';



class SalaryApiService {
  Future<Map<String, dynamic>> fetchSalary({
    required String userAutoId,
    required String startMonth,
    required String endMonth,
  }) async {
    final response = await http.post(
      Uri.parse(ApiString.get_salary),
      body: {
        "user_auto_id": userAutoId,
        "start_month": startMonth,
        "end_month": endMonth,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception("Failed to fetch salary: ${response.statusCode}");
    }
  }
}