import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repository/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class AttendanceBloc extends Bloc<DashboardEvent, DashboardState> {

  final AttendanceRepository repository;

  AttendanceBloc(this.repository) : super(DashboardInitial()) {

    on<LoadMonthlyAttendance>((event, emit) async {

      emit(DashboardLoading());

      try {

        final dashboardData = await repository.getMonthlyAttendance(
          userId: event.userId,
          adminId: event.adminId,
          appTypeId: event.appTypeId,
          month: event.month,
          year: event.year,
        );

        print("Dashboard Loaded Total Task: ${dashboardData.totalTask}");

        emit(DashboardLoaded(dashboardData));

      } catch (e) {

        emit(DashboardError(e.toString()));

      }

    });

  }
}