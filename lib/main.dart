import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';

// Repositories
import 'core/repository/dashboard_repository.dart';
import 'core/repository/leave_repository.dart';
import 'core/repository/profile_repository.dart';
import 'core/repository/salary_repository.dart';
import 'core/services/salary_api_service.dart';

// Blocs
import 'features/Leave/leave_screen.dart';
import 'features/attendance/Bloc/dashboard_bloc.dart';
import 'features/Leave/Bloc/leave_bloc.dart';
import 'features/gps_attendance/binding/gps_attendance_binding.dart';
import 'features/mark_attendance/binding/mark_attendance_binding.dart';
import 'features/mark_attendance/screen/mark_attendance_screen.dart';
import 'features/profile/Bloc/profile_bloc.dart';
import 'features/salary/Bloc/salary_bloc.dart';

// Routes & Bindings
import 'core/bindings/dashboard_binding.dart';
import 'core/bindings/shift_binding.dart';
import 'core/bindings/apply_leave_binding.dart';

// Screens
import 'features/dashboard/View/dashboard_view.dart';
import 'features/shared/active_shift_manager.dart';
import 'features/shift/screen/shift_screen.dart';
import 'features/shift/screen/my_sites_screen.dart';
import 'features/ApplyLeaves/screen/apply_leave_screen.dart';
import 'features/notification/view/notification_view.dart';
import 'features/attendance/dashboard_tab.dart';
import 'features/profile/profileScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ActiveShiftManager(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AttendanceRepository>(
              create: (_) => AttendanceRepository(),
            ),
            RepositoryProvider<LeaveRepository>(
              create: (_) => LeaveRepository(),
            ),
            RepositoryProvider<ProfileRepository>(
              create: (_) => ProfileRepository(),
            ),
            RepositoryProvider<SalaryRepository>(
              create: (_) => SalaryRepository(
                SalaryApiService(),
              ),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AttendanceBloc>(
                create: (context) => AttendanceBloc(
                  context.read<AttendanceRepository>(),
                ),
              ),
              BlocProvider<LeaveBloc>(
                create: (context) => LeaveBloc(
                  context.read<LeaveRepository>(),
                ),
              ),
              BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(
                  repository: context.read<ProfileRepository>(),
                ),
              ),
              BlocProvider<SalaryBloc>(
                create: (context) => SalaryBloc(
                  context.read<SalaryRepository>(),
                ),
              ),
            ],
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Shift Management',
              theme: AppTheme.lightTheme,
              initialRoute: '/dashBoard',

              getPages: [
                GetPage(
                  name: '/dashBoard',
                  page: () => const DashboardView(),
                  bindings: [
                    DashboardBinding(),
                    GpsAttendanceBinding(),
                  ],
                ),

                GetPage(
                  name: '/shifts',
                  page: () => ShiftScreen(),
                  binding: ShiftBinding(),
                ),

                GetPage(
                  name: '/sites',
                  page: () => MySitesScreen(),
                  binding: ShiftBinding(),
                ),


                GetPage(
                  name: '/apply-leave',
                  page: () => ApplyLeaveScreen(),
                  binding: ApplyLeaveBinding(),
                ),

                GetPage(
                  name: '/notification',
                  page: () => NotificationView(),
                ),

                GetPage(
                  name: '/profile',
                  page: () => ProfileTab(),
                ),

                GetPage(
                  name: '/leave',
                  page: () => const LeaveTab(),
                ),

                GetPage(
                  name: '/attendance',
                  page: () => const AttendancePage(),
                ),


                GetPage(
                  name: '/mark-attendance',
                  page: () =>
                  MarkAttendanceScreen(),
                  binding:
                  MarkAttendanceBinding(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}