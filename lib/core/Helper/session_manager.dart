import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // ---------------- KEYS ----------------
  static const _keyIsLoggedIn = "is_logged_in";
  static const _keyUserId = "user_id";
  static const _keyAdminAutoId = "admin_auto_id";
  static const _keyAppTypeId = "app_type_id";
  static const _keyLastProfileUpdate = "last_profile_update";
  static const UserType = "Employee";


  // ---------------- LOGIN SESSION ----------------

  static Future<void> saveLoginSession({
    required String userId,
    required String adminAutoId,
    required String appTypeId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyAdminAutoId, adminAutoId);
    await prefs.setString(_keyAppTypeId, appTypeId);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ---------------- GETTERS ----------------

  static Future<String> getUserIdOrThrow() async {
    final id = await getUserId();
    if (id == null || id.isEmpty) {
      throw Exception("User ID not found in session");
    }
    return id;
  }

  static Future<String> getAdminAutoIdOrThrow() async {
    final id = await getAdminAutoId();
    if (id == null || id.isEmpty) {
      throw Exception("Admin Auto ID not found in session");
    }
    return id;
  }

  static Future<String> getAppTypeIdOrThrow() async {
    final id = await getAppTypeId();
    if (id == null || id.isEmpty) {
      throw Exception("App Type ID not found in session");
    }
    return id;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getAdminAutoId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAdminAutoId);
  }


  // ---------------- ATTENDANCE SESSION ----------------

  static const String attendanceMarked = "attendance_marked";
  static const String attendanceId = "attendance_id";

  static Future<void> saveAttendanceSession({
    required String id,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(attendanceId, id);
    await prefs.setString(attendanceMarked, "yes");
  }

  static Future<void> clearAttendanceSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(attendanceMarked);
    await prefs.remove(attendanceId);
  }

  static Future<bool> isPunchedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(attendanceMarked) == "yes";
  }

  static Future<String?> getAttendanceMarked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(attendanceMarked);
  }

  static Future<String?> getAttendanceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(attendanceId);
  }

  static Future<String?> getAppTypeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAppTypeId);
  }

  static Future<void> setAttendanceMarked(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(attendanceMarked, value);
  }

  // ---------------- PROFILE UPDATE TIME ----------------

  static Future<void> saveProfileUpdatedTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyLastProfileUpdate,
      DateTime.now().toIso8601String(),
    );
  }

  static Future<DateTime?> getLastProfileUpdatedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final time = prefs.getString(_keyLastProfileUpdate);
    return time != null ? DateTime.parse(time) : null;
  }

  // ---------------- UTILITIES ----------------

  static Future<bool> hasValidSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUserId) &&
        prefs.containsKey(_keyAdminAutoId) &&
        prefs.containsKey(_keyAppTypeId);
  }


  static Future<Map<String, String>> getSessionPayload() async {
    return {
      'user_auto_id': await getUserIdOrThrow(),
      'admin_auto_id': await getAdminAutoIdOrThrow(),
      'app_type_id': await getAppTypeIdOrThrow(),
    };
  }


  // ---------------- LOGOUT ----------------

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}

