import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadMonthlyAttendance extends DashboardEvent {
  final String userId;
  final String adminId;
  final String appTypeId;
  final int month;
  final int year;

  LoadMonthlyAttendance({
    required this.userId,
    required this.adminId,
    required this.appTypeId,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [userId, month, year];
}