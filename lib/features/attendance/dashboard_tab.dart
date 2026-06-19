import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:table_calendar/table_calendar.dart';






import '../../core/Helper/appImages.dart';
import '../../core/Helper/commonDecoration.dart';
import '../../core/Helper/session_manager.dart';
import '../../core/theme/appSpacing.dart';
import '../../core/theme/app_colors2.dart';
import 'Bloc/dashboard_bloc.dart';
import 'Bloc/dashboard_event.dart';
import 'Bloc/dashboard_state.dart';


class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with TickerProviderStateMixin {

  bool _showCalendar = false;

  DateTime _selectedMonth = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

   String userId = "";
  String adminId = '';
  String appTypeId = '';

  final List<Map<String, dynamic>> statusItems = [
    {'status': 'Present', 'count': 0, 'bgColor': Colors.green.shade50, 'statusColor': Colors.green.shade800},
    {'status': 'Absent', 'count': 0, 'bgColor': Colors.red.shade50, 'statusColor': Colors.red.shade800},
    {'status': 'Leave', 'count': 0, 'bgColor': Colors.orange.shade50, 'statusColor': Colors.orange.shade800},
    {'status': 'Public Holiday', 'count': 0, 'bgColor': Colors.blue.shade50, 'statusColor': Colors.blue.shade800},
    {'status': 'Pending', 'count': 0, 'bgColor': Colors.grey.shade100, 'statusColor': Colors.grey},
    {'status': 'Weekly Off', 'count': 0, 'bgColor': Colors.white, 'statusColor': Colors.grey},
  ];

  final List<Map<String, dynamic>> items = [
    {'title': 'Total Task', 'description': '0', 'image': AppImages.calenderIcon},
    {'title': '00:00:00', 'description': 'Total hrs', 'image': AppImages.clockIcon},
    {'title': '0 Km', 'description': 'Distance travelled', 'image': AppImages.distanceIcon},
    {'title': 'Good', 'description': 'App setup', 'image': AppImages.phoneIcon},
  ];

   @override
  void initState() {
    super.initState();

    _loadSessionAndFetchDashboard();

  }

  Future<void> _loadSessionAndFetchDashboard() async {
    try {
      userId = await SessionManager.getUserIdOrThrow();
      adminId = await SessionManager.getAdminAutoIdOrThrow();
      appTypeId = await SessionManager.getAppTypeIdOrThrow();

      if (!mounted) return;

      context.read<AttendanceBloc>().add(
        LoadMonthlyAttendance(
          userId: userId,
          adminId: adminId,
          appTypeId: appTypeId,
          month: _selectedMonth.month,
          year: _selectedMonth.year,
        ),
      );
    } catch (e) {
      debugPrint("Session error: $e");
    }
  }

  void _showMonthPicker(BuildContext context) async {

    final picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {

      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
        _focusedDay = _selectedMonth;
      });

      context.read<AttendanceBloc>().add(
        LoadMonthlyAttendance(
          userId: userId,
          adminId: adminId,
          appTypeId: appTypeId,
          month: _selectedMonth.month,
          year: _selectedMonth.year,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocBuilder<AttendanceBloc, DashboardState>(
        builder: (context, state) {

          if (state is DashboardLoading && items[0]['description'] == '0') {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {

            final data = state.data;

            statusItems[0]['count'] = data.summary.present;
            statusItems[1]['count'] = data.summary.absent;
            statusItems[2]['count'] = data.summary.leave;
            statusItems[3]['count'] = data.summary.publicHoliday;
            statusItems[4]['count'] = data.summary.pending;
            statusItems[5]['count'] = data.summary.weeklyOff;

            items[0]['description'] = data.totalTask.toString();
            items[1]['title'] = data.totalHours;
            items[2]['title'] = "${data.totalDistance} Km";
          }

          if (state is DashboardError) {
            return Center(child: Text(state.message));
          }

          return _dashboardUI();
        },
      )
      ,
    );
  }

   Widget _dashboardUI() {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          children: [

             Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

              decoration: CommonDecorations.boxDecoration(
                borderRadius: 0,
                backgroundColor: AppColor.lightSkyBlue,
                borderColor: Colors.white,
              ),

              child: Row(
                children: [

                  Image.asset(AppImages.speakerIcon,
                      color: AppColor.darkSkyBlue,
                      height: 25.h),

                  AppSpacing.w8,

                  const Expanded(
                    child: Text(
                      "Learn how to add clients and photos in the new workflow.",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),

                  Image.asset(AppImages.pdfIcon, height: 25.h),

                ],
              ),
            ),

            AppSpacing.h10,

             Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

              decoration: CommonDecorations.boxDecoration(
                backgroundColor: AppColor.lightblue,

                customBorderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),

              child: Row(
                children: [

                  Image.asset(AppImages.calenderIcon,
                      color: Colors.white,
                      height: 20.h),

                  AppSpacing.w8,

                  Expanded(
                    child: Text(
                      "${_selectedMonth.month}/${_selectedMonth.year}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => _showMonthPicker(context),
                    child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white),
                  )

                ],
              ),
            ),

             Container(
              padding: const EdgeInsets.all(12),
              decoration: CommonDecorations.boxDecoration(
                backgroundColor: AppColor.darkSkyBlue,
                customBorderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child:
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: statusItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 1.5,
                ),
                itemBuilder: (_, index) {
                  final item = statusItems[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: item['bgColor'],
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                         Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: item['statusColor'],
                            shape: BoxShape.circle,
                          ),
                        ),

                        AppSpacing.w8,

                         Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                item['status'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                               Text(
                                item['count'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: item['statusColor'],
                                ),
                              ),

                              const SizedBox(height: 2),



                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

             AppSpacing.h10,

            TableCalendar(
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),

              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,

              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),

               availableGestures: AvailableGestures.horizontalSwipe,

              onPageChanged: (day) {
                _focusedDay = day;
                _selectedMonth = DateTime(day.year, day.month);

                context.read<AttendanceBloc>().add(
                  LoadMonthlyAttendance(
                    userId: userId,
                    adminId: adminId,
                    appTypeId: appTypeId,
                    month: day.month,
                    year: day.year,
                  ),
                );
              },
            ),

             AppSpacing.h10,

            GridView.builder(

              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: items.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 5 / 2.2,
              ),

              itemBuilder: (_, index) {

                final item = items[index];

                return Card(

                  child: Padding(
                    padding: const EdgeInsets.all(10),

                    child: Row(
                      children: [

                        Image.asset(item['image'], height: 22),

                        AppSpacing.w10,

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text(
                              item['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),

                            Text(
                              item['description'],
                              style: const TextStyle(fontSize: 12),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}