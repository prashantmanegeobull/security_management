import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/model/attendance_model.dart';
import '../../../core/repository/attendance_repository.dart';

import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {

  final AttendanceRepository repository;

  AttendanceBloc(this.repository) : super(AttendanceInitial()) {

    on<FetchMonthlyAttendance>(_fetchMonthlyAttendance);
    on<FetchDailyAttendance>(_fetchDailyAttendance);
  }

  Future<void> _fetchMonthlyAttendance(
      FetchMonthlyAttendance event,
      Emitter<AttendanceState> emit,
      ) async {

    try {

      emit(AttendanceLoading());

      final data = await repository.getMonthlyAttendance(
        userId: event.userId,
        adminId: event.adminId,
        appTypeId: event.appTypeId,
        month: event.month,
        year: event.year,
      );

      double totalDistance = 0;
      Duration totalHours = Duration.zero;
      AttendanceModel? today;

      DateTime now = DateTime.now();

      DateTime? firstLogin;
      DateTime? lastLogout;

      for (var e in data) {

        totalDistance += double.tryParse(e.distanceTravelled ?? "0") ?? 0;

        DateTime date = e.date ?? e.createdAt;

        if (date.year == now.year &&
            date.month == now.month &&
            date.day == now.day) {
          today = e;
        }

        if (e.loginTime != null) {
          final t = DateFormat("HH:mm").parse(e.loginTime!);
          firstLogin = DateTime(now.year, now.month, now.day, t.hour, t.minute);
        }

        if (e.logoutTime != null) {
          final t = DateFormat("HH:mm").parse(e.logoutTime!);
          lastLogout = DateTime(now.year, now.month, now.day, t.hour, t.minute);
        }
      }

      if (firstLogin != null && lastLogout != null) {
        totalHours = lastLogout.difference(firstLogin);
      }

      emit(
        AttendanceLoaded(
          attendances: data,
          today: today,
          totalDistance: totalDistance,
          totalHours: totalHours,
        ),
      );

    } catch (e) {

      emit(AttendanceError(e.toString()));

    }
  }

  Future<void> _fetchDailyAttendance(
      FetchDailyAttendance event,
      Emitter<AttendanceState> emit,
      ) async {

    try {

      emit(AttendanceLoading());

      final data = await repository.getAttendance(
        userId: event.userId,
        adminId: event.adminId,
        appTypeId: event.appTypeId,
        date: event.date,
      );

      emit(
        AttendanceLoaded(
          attendances: data,
          today: data.isNotEmpty ? data.first : null,
          totalDistance: 0,
          totalHours: Duration.zero,
        ),
      );

    } catch (e) {

      emit(AttendanceError(e.toString()));

    }
  }
}