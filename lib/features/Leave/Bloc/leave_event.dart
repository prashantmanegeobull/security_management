import 'package:equatable/equatable.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object?> get props => [];
}

 class FetchLeavesEvent extends LeaveEvent {
  final String userAutoId;
  final String adminAutoId;
  final String appTypeId;

  const FetchLeavesEvent({
    required this.userAutoId,
    required this.adminAutoId,
    required this.appTypeId,
  });

  @override
  List<Object?> get props => [
    userAutoId,
    adminAutoId,
    appTypeId,
  ];
}

 class ApplyLeaveEvent extends LeaveEvent {
  final String userAutoId;
  final String adminAutoId;
  final String appTypeId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String isHalfDay;
  final String shift;
  final String reason;
  final String weeklyLeave;

  const ApplyLeaveEvent({
    required this.userAutoId,
    required this.adminAutoId,
    required this.appTypeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.isHalfDay,
    required this.shift,
    required this.reason,
    required this.weeklyLeave,
  });

  @override
  List<Object?> get props => [
    userAutoId,
    adminAutoId,
    appTypeId,
    leaveType,
    startDate,
    endDate,
    isHalfDay,
    shift,
    reason,
    weeklyLeave,
  ];
}


class ResetLeaveEvent extends LeaveEvent {
  const ResetLeaveEvent();
}