import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';


import '../../core/Helper/ApiString.dart';
import '../../core/Helper/appImages.dart';
import '../../core/Helper/commonDecoration.dart';
import '../../core/Helper/session_manager.dart';
import '../../core/model/attendance_model.dart';
import '../../core/theme/appSpacing.dart';
import '../../core/theme/app_colors2.dart';
import 'Bloc/attendance_bloc.dart';
import 'Bloc/attendance_event.dart';
import 'Bloc/attendance_state.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late Completer<GoogleMapController> _controller;
  GoogleMapController? _mapController;

  LatLng _selectedLocation = const LatLng(0, 0);

  DateTime _selectedMonth = DateTime.now();

  final List<DateTime> _daysInMonth = [];
  final Map<DateTime, Color> _attendanceStatus = {};
  String? userId;
  String? adminId;
  String? appTypeId;

  DateTime? _selectedDay;
  AttendanceModel? _selectedAttendance;
  double _selectedDistance = 0;
  Duration _selectedHours = Duration.zero;
  int _selectedTasks = 0;
  double monthlyDistance = 0;


  @override
  void initState() {
    super.initState();
    _controller = Completer();

    _generateDaysInMonth();
    _initUser();
   }

  Future<void> _initUser() async {

    userId = await SessionManager.getUserIdOrThrow();
    adminId = await SessionManager.getAdminAutoIdOrThrow();
    appTypeId = await SessionManager.getAppTypeIdOrThrow();

    if (mounted) {
      _loadMonth(_selectedMonth);
    }
  }

  void _loadMonth(DateTime month) {

    if (userId == null || adminId == null || appTypeId == null) {
      debugPrint("Missing IDs");
      return;
    }

    context.read<AttendanceBloc>().add(
      FetchMonthlyAttendance(
        userId: userId!,
        adminId: adminId!,
        appTypeId: appTypeId!,
        month: DateFormat('MM').format(month),
        year: DateFormat('yyyy').format(month),
      ),
    );
  }

  void _generateDaysInMonth() {
    _daysInMonth.clear();

    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final nextMonth =
    DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);

    final dayCount = nextMonth.difference(firstDay).inDays;

    for (int i = 0; i < dayCount; i++) {
      _daysInMonth.add(firstDay.add(Duration(days: i)));
    }
  }

  void _mapAttendanceToCalendar(List<AttendanceModel> data) {
    _attendanceStatus.clear();

    for (final item in data) {

      if (item.createdAt == null) continue;

      final key = DateTime(
        item.createdAt!.year,
        item.createdAt!.month,
        item.createdAt!.day,
      );

      _attendanceStatus[key] =
      item.dayStatus.toLowerCase() == "present"
          ? Colors.green.shade200
          : Colors.red.shade200;
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
        _selectedMonth = picked;
        _generateDaysInMonth();
        _attendanceStatus.clear();
      });

      _loadMonth(picked);
    }
  }


  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return "${h}h ${m}m";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {

          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceError) {
            return Center(child: Text(state.message));
          }

          AttendanceModel? today;
          double distance = 0;
          Duration hours = Duration.zero;

          if (state is AttendanceLoaded) {

            monthlyDistance = state.totalDistance;

            _mapAttendanceToCalendar(state.attendances);

          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Container(
                    decoration: CommonDecorations.boxDecoration(
                      borderRadius: 10,
                      backgroundColor: AppColor.whiteColor,
                      borderColor: Colors.grey.shade300,
                    ),
                    child: Column(
                      children: [

                        GestureDetector(
                          onTap: () => _showMonthPicker(context),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMMM yyyy')
                                      .format(_selectedMonth),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _daysInMonth.length,
                              itemBuilder: (_, index) {

                                final date = _daysInMonth[index];

                                final key = DateTime(date.year, date.month, date.day);

                                final color = _attendanceStatus[key] ?? Colors.grey.shade300;

                                return SizedBox(
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Text(DateFormat('E').format(date)),

                                      GestureDetector(
                                        onTap: () async {

                                          if (state is AttendanceLoaded) {

                                            setState(() {
                                              _selectedDay = date;
                                            });

                                            // final selectedList = state.attendances.where((e) =>
                                            // e.createdAt.year == date.year &&
                                            //     e.createdAt.month == date.month &&
                                            //     e.createdAt.day == date.day).toList();
                                            //
                                            // _selectedDistance = 0;
                                            // _selectedHours = Duration.zero;
                                            // _selectedAttendance = null;
                                            //
                                            // DateTime? login;
                                            //
                                            // for (var item in selectedList) {
                                            //
                                            //   _selectedAttendance ??= item;
                                            //
                                            //   _selectedDistance +=
                                            //       double.tryParse(item.distanceTravelled ?? "0") ?? 0;
                                            //
                                            //   if (item.loginTime != null) {
                                            //     login = DateFormat("HH:mm").parse(item.loginTime!);
                                            //   }
                                            //
                                            //   if (item.logoutTime != null && login != null) {
                                            //     final logout = DateFormat("HH:mm").parse(item.logoutTime!);
                                            //
                                            //     if (logout.isAfter(login)) {
                                            //       _selectedHours += logout.difference(login);
                                            //     }
                                            //
                                            //     login = null;
                                            //   }
                                            // }

                                             String formattedDate = DateFormat('yyyy-MM-dd').format(date);

                                            final response = await http.post(
                                              Uri.parse(ApiString.getTaskLists),
                                              body: {
                                                "user_auto_id": userId!,
                                                "admin_auto_id": adminId!,
                                                "app_type_id": appTypeId!,
                                                "date": formattedDate,
                                              },
                                            );

                                            final json = jsonDecode(response.body);

                                            int tasks = 0;

                                            if (json["status"] == 1) {

                                              List data = json["data"] ?? [];

                                              for (var item in data) {
                                                List taskDetails = item["task_details"] ?? [];
                                                tasks += taskDetails.length;
                                              }
                                            }

                                            setState(() {
                                              _selectedTasks = tasks;
                                            });

                                          }

                                        },

                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (_selectedDay != null &&
                                                _selectedDay!.year == date.year &&
                                                _selectedDay!.month == date.month &&
                                                _selectedDay!.day == date.day)
                                                || (_selectedDay == null &&
                                                    DateTime.now().year == date.year &&
                                                    DateTime.now().month == date.month &&
                                                    DateTime.now().day == date.day)
                                                ? AppColor.greenColor
                                                : color,
                                          ),
                                          child: Text(
                                            DateFormat('d').format(date),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),



                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 5 / 2.2,
                    children: [

                      _card(
                        _selectedAttendance?.dayStatus ?? "-",
                        "Status",
                        AppImages.calenderIcon,
                      ),

                      _card(
                        (_selectedAttendance?.dayStatus.toLowerCase() == "absent")
                            ? "0h 0m"
                            : _formatDuration(_selectedHours),
                        "Total hrs",
                        AppImages.clockIcon,
                      ),

                      _card(
                        "${_selectedDistance.toStringAsFixed(2)} Km",
                        "Distance travelled",
                        AppImages.distanceIcon,
                      ),

                      _card(
                        _selectedTasks.toString(),
                        "Tasks",
                        AppImages.phoneIcon,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),


                  // Card(
                  //   elevation: 0.3,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10),
                  //     child: Row(
                  //       children: [
                  //         Image.asset(
                  //           AppImages.clockIcon,
                  //           height: 23.h,
                  //           width: 23.w,
                  //           fit: BoxFit.cover,
                  //           color: AppColor.blackColor,
                  //         ),
                  //         AppSpacing.w10,
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 "11:15 hrs",
                  //                 style: TextStyle(
                  //                   fontSize: 14.sp,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //
                  //               AppSpacing.h6,
                  //
                  //               Text(
                  //                 "Total Hours",
                  //                 style: TextStyle(
                  //                   fontSize: 12.sp,
                  //                   color: Colors.grey[700],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: 20),
                  Text('Attendance Result', style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text(
                        "Present",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text('Shift details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Expected :', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('09:00 hrs', style: TextStyle(color: Colors.grey[600])),
                                  SizedBox(height: 5,),
                                  Text('09:30 AM- 06:30 PM', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),

                            ],
                          ),

                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text('Actual :', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('09:00 hrs', style: TextStyle(color: Colors.grey[600])),
                                  SizedBox(height: 5,),
                                  Text('09:30 AM- 06:30 PM', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),





                  Text('Route',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),

                  SizedBox(
                    height: 400.h,
                    child: Stack(
                      children: [

                        GoogleMap(
                          onMapCreated: (c) => _mapController = c,
                          initialCameraPosition: CameraPosition(
                            target: _selectedLocation,
                            zoom: 13,
                          ),
                          markers: {
                            Marker(
                              markerId:
                              const MarkerId("selected-location"),
                              position: _selectedLocation,
                            ),
                          },
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                        ),

                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration:
                            CommonDecorations.boxDecoration(
                              borderRadius: 8,
                              backgroundColor:
                              AppColor.whiteColor,
                              borderColor:
                              AppColor.greyColor,
                            ),
                            child: Text(
                              "Total Distance: ${monthlyDistance.toStringAsFixed(2)} Km",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _card(String title, String subtitle, String image) {
    return Card(
      elevation: 0.3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(image,
                height: 22,
                width: 22,
                color: AppColor.blackColor),
            AppSpacing.w10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
