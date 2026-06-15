// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'dashboard_event.dart';
// import 'dashboard_state.dart';
//
// class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
//
//   final DashboardRepository repository;
//
//   DashboardBloc(this.repository) : super(DashboardInitial()) {
//
//     on<LoadMonthlyAttendance>((event, emit) async {
//
//       emit(DashboardLoading());
//
//       try {
//
//         final dashboardData = await repository.getMonthlyAttendance(
//           userId: event.userId,
//           adminId: event.adminId,
//           appTypeId: event.appTypeId,
//           month: event.month,
//           year: event.year,
//         );
//
//         print("Dashboard Loaded Total Task: ${dashboardData.totalTask}");
//
//         emit(DashboardLoaded(dashboardData));
//
//       } catch (e) {
//
//         emit(DashboardError(e.toString()));
//
//       }
//
//     });
//
//   }
// }