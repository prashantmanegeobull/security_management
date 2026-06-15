import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:security_management/core/bindings/dashboard_binding.dart';

import '../core/repository/attendance_repository.dart';
import '../core/repository/leave_repository.dart';
import '../features/Leave/Bloc/leave_bloc.dart';
import '../features/Leave/leave_screen.dart';
import '../features/attendance/Bloc/attendance_bloc.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/dashBoard/View/dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [

    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),

    GetPage(
      name: AppRoutes.leave,
      page: () => BlocProvider(
        create: (_) => LeaveBloc(
          LeaveRepository(),
        ),
        child: const LeaveTab(),
      ),
    ),

    GetPage(
      name: AppRoutes.attendance,
      page: () => BlocProvider(
        create: (_) => AttendanceBloc(
          AttendanceRepository(),
        ),
        child: const AttendancePage(),
      ),
    ),

  ];
}