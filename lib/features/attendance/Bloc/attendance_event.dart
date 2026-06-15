import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMonthlyAttendance extends AttendanceEvent {

  final String userId;
  final String adminId;
  final String appTypeId;
  final String month;
  final String year;

  FetchMonthlyAttendance({
    required this.userId,
    required this.adminId,
    required this.appTypeId,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [userId, month, year];
}

class FetchDailyAttendance extends AttendanceEvent {

  final String userId;
  final String adminId;
  final String appTypeId;
  final String date;

  FetchDailyAttendance({
    required this.userId,
    required this.adminId,
    required this.appTypeId,
    required this.date,
  });

  @override
  List<Object?> get props => [userId, date];
}