import 'package:equatable/equatable.dart';
import '../../../core/model/attendance_model.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {

  final List<AttendanceModel> attendances;
  final AttendanceModel? today;
  final double totalDistance;
  final Duration totalHours;

  AttendanceLoaded({
    required this.attendances,
    required this.today,
    required this.totalDistance,
    required this.totalHours,
  });

  @override
  List<Object?> get props =>
      [attendances, today, totalDistance, totalHours];
}

class AttendanceError extends AttendanceState {

  final String message;

  AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}