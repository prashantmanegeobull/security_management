import 'package:flutter/material.dart';
import '../../core/model/shift_model.dart';

class ShiftTimeValidator {

  /// Returns true if current time is AFTER or EQUAL shift start time
  static bool canMarkAttendance(ShiftModel shift) {
    final now = TimeOfDay.now();

    final start = _parseTime(shift.startTime);
    if (start == null) return false;

    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;

    return nowMinutes >= startMinutes;
  }

  /// Returns true if current time is BEFORE or EQUAL shift end time
  static bool canLogout(ShiftModel shift) {
    final now = TimeOfDay.now();

    final end = _parseTime(shift.endTime);
    if (end == null) return false;

    final nowMinutes = now.hour * 60 + now.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return nowMinutes >= endMinutes;
  }

  static TimeOfDay? _parseTime(String time) {
    try {
      final clean = time.trim().toUpperCase();

      final isPM = clean.contains("PM");
      final isAM = clean.contains("AM");

      final timePart = clean
          .replaceAll("AM", "")
          .replaceAll("PM", "")
          .trim();

      final parts = timePart.split(":");
      if (parts.length != 2) return null;

      int hour = int.parse(parts[0]);
      final int minute = int.parse(parts[1]);

      if (isPM && hour != 12) hour += 12;
      if (isAM && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }
}