import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

 import '../../core/Helper/ApiString.dart';
import '../../core/Helper/commonDecoration.dart';
import '../../core/Helper/session_manager.dart';
import '../../core/model/leave_model.dart';
import '../../core/theme/app_colors2.dart';
import 'Bloc/leave_bloc.dart';
import 'Bloc/leave_event.dart';
import 'Bloc/leave_state.dart';
import 'leaveTypes.dart';

class LeaveTab extends StatefulWidget {


  const LeaveTab({
    super.key,

  });

  @override
  State<LeaveTab> createState() => _LeaveTabState();
}

class _LeaveTabState extends State<LeaveTab> {

   String selectedLeaveType = 'Emergency';
   String selectedWeeklyLeaveType = 'Weekly Leave';
  bool isHalfDay = false;
  bool weeklyLeave = false;
   String selectedHalfDayLeaveType = 'Emergency';
   String selectedShift = 'First';
   LeaveTypesResponse? leaveTypesResponse;
   bool isLoading = true;



   final TextEditingController manualLeaveTypeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
   final TextEditingController singleDateController = TextEditingController();



   List<String> getLeaveTypes() {
     List<String> types = [
       'Emergency',
       'Casual',
       'Optional',
       'Other',
     ];

     final hasFamilyVillage = leaveTypesResponse?.data.any((leave) {
       final type = leave.leaveType
           .toLowerCase()
           .replaceAll('_', '-')
           .replaceAll('/', '-')
           .trim();

       return type.contains('family-village');
     }) ??
         false;

     if (hasFamilyVillage) {
       types.insert(3, 'Family/Village');
     }

     return types;
   }


   final List<String> weeklyLeaveTypes = [
     'Weekly Leave',
   ];

   List<String> getHalfDayLeaveTypes() {
     List<String> types = [
       'Emergency',
       'Casual',
       'Optional',
       'Other',
     ];

     final hasFamilyVillage = leaveTypesResponse?.data.any((leave) {
       final type = leave.leaveType
           .toLowerCase()
           .replaceAll('_', '-')
           .replaceAll('/', '-')
           .trim();

       return type.contains('family-village');
     }) ??
         false;

     if (hasFamilyVillage) {
       types.insert(3, 'Family/Village');
     }

     return types;
   }

   final List<String> shifts = [
     'First',
     'Second',
   ];


  String _selectedFilter = 'Approved';
  final List<String> _filters = ['Approved', 'Disapproved', 'Pending'];

  @override

  void initState() {
    super.initState();
    fetchLeaveTypes();
    _loadSessionAndFetch();

  }

   Future<void> fetchLeaveTypes() async {
     try {
       print("API CALL STARTED");

       final userId = await SessionManager.getUserId();

       final response = await http.post(
         Uri.parse(ApiString.get_leave_type),
         body: {
           "user_auto_id": userId ?? "",
         },
       );

       print("STATUS CODE: ${response.statusCode}");
       print("BODY: ${response.body}");

       if (response.statusCode == 200) {
         final jsonData = jsonDecode(response.body);

         if (jsonData["status"] == 1) {
           setState(() {
             leaveTypesResponse = LeaveTypesResponse.fromJson(jsonData);
             isLoading = false;
           });

           print("DATA LOADED SUCCESS");
         } else {
           setState(() {
             isLoading = false;
           });

           print(jsonData["msg"]);
         }
       }
     } catch (e) {
       print("ERROR: $e");

       setState(() {
         isLoading = false;
       });
     }
   }

   Future<void> _loadSessionAndFetch() async {
     final userId = await SessionManager.getUserId();
     final adminId = await SessionManager.getAdminAutoId();
     final appTypeId = await SessionManager.getAppTypeId();

     context.read<LeaveBloc>().add(
       FetchLeavesEvent(
         userAutoId: userId!,
         adminAutoId: adminId!,
         appTypeId: appTypeId!,
       ),
     );
   }


  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text = _dateFormat.format(pickedDate);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state is LeaveAppliedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
        body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

             Row(
              children: _filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: _selectedFilter == filter
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    selected: _selectedFilter == filter,
                    selectedColor: AppColor.darkSkyBlue,
                    backgroundColor: Colors.grey[200],
                    onSelected: (_) async {
                      setState(() {
                        _selectedFilter = filter;
                      });

                      final userId = await SessionManager.getUserId();
                      final adminId = await SessionManager.getAdminAutoId();
                      final appTypeId = await SessionManager.getAppTypeId();

                      context.read<LeaveBloc>().add(
                        FetchLeavesEvent(
                          userAutoId: userId!,
                          adminAutoId: adminId!,
                          appTypeId: appTypeId!,
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

             BlocBuilder<LeaveBloc, LeaveState>(
              builder: (context, state) {

                if (state is LeaveLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is LeaveLoaded) {
                  final filteredLeaves = state.leaves.where((leave) {
                    if (_selectedFilter == 'Disapproved') {
                      return leave.status == 'Rejected';
                    }
                    return leave.status == _selectedFilter;
                  }).toList();

                  if (filteredLeaves.isEmpty) {
                    return const Center(child: Text("No leave records found"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = filteredLeaves[index];
                      return _leaveCard(leave);
                    },
                  );
                }

                if (state is LeaveError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),

       floatingActionButton: GestureDetector(
        onTap: () => _showLeaveApplicationBottomSheet(context),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: AppColor.darkSkyBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
        ),
    );
  }

   Widget _leaveCard(LeaveModel leave) {
    return GestureDetector(
      onTap: () => _showLeaveDetails(context, leave),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: CommonDecorations.boxDecoration(
          borderRadius: 10,
          backgroundColor: AppColor.whiteColor,
          borderColor: Colors.grey.shade200,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  leave.isHalfDay == 'Yes'
                      ? 'Half Day Application'
                      : 'Full Day Application',
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
                const SizedBox(height: 4),
                Text(
                  leave.isHalfDay == 'Yes'
                      ? leave.startDate
                      : '${leave.startDate} - ${leave.endDate}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${leave.leaveType} Leave',
                  style: TextStyle(
                    fontSize: 14,
                    color: leave.status == 'Approved'
                        ? Colors.green
                        : leave.status == 'Rejected'
                        ? Colors.red
                        : Colors.orange,
                  ),
                ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: leave.status == 'Approved'
                    ? Colors.green.shade100
                    : leave.status == 'Rejected'
                    ? Colors.red.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                leave.status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: leave.status == 'Approved'
                      ? Colors.green
                      : leave.status == 'Rejected'
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

   void _showLeaveApplicationBottomSheet(BuildContext context) {
     showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       backgroundColor: Colors.white,
       builder: (_) {
         return StatefulBuilder(
           builder: (context, setStateSheet) {
             return Padding(
               padding: MediaQuery.of(context).viewInsets,
               child: SingleChildScrollView(
                 padding: const EdgeInsets.all(16),
                 child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                       const Text('Apply Leave',
                           style:
                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                       const SizedBox(height: 16),

                       const Divider(),

                       isLoading
                           ? const Center(child: CircularProgressIndicator())
                           : leaveTypesResponse == null
                           ? const Text("No data found")
                           : Text(
                         'Total Leaves/Year : ${leaveTypesResponse!.totalLeave} \n'
                             'Remaining Total Leave : ${leaveTypesResponse!.remainingYearlyLeave}\n'
                             '${leaveTypesResponse!.data.map((leave) =>
                         "${leave.leaveType} : ${leave.leavesCount}").join("\n")}',
                         style: TextStyle(
                           fontSize: 14,
                           color: Colors.grey[700],
                           height: 1.5,
                         ),
                       ),
                       const SizedBox(height: 5),


                       const Divider(),

                       //const SizedBox(height: 16),

                       Row(
                         children: [
                           Checkbox(
                             value: isHalfDay,
                             onChanged: (v) {
                               setStateSheet(() {
                                 isHalfDay = v!;

                                 selectedLeaveType = 'Emergency';
                                 selectedHalfDayLeaveType = 'Emergency';
                                 selectedShift = 'First';

                                 startDateController.clear();
                                 endDateController.clear();
                                 singleDateController.clear();
                                 manualLeaveTypeController.clear();
                                 reasonController.clear();
                               });
                             },
                           ),

                           const Text('Is Half Day Leave?'),

                           Checkbox(
                             value: weeklyLeave,
                             onChanged: (leaveTypesResponse?.weeklyLeave ?? 0) == 0
                                 ? null
                                 : (w) {
                               setStateSheet(() {
                                 weeklyLeave = w!;

                                 startDateController.clear();
                                 endDateController.clear();
                                 singleDateController.clear();
                                 manualLeaveTypeController.clear();
                                 reasonController.clear();
                               });
                             },
                           ),

                           Text(
                             'Weekly Leave : ${leaveTypesResponse?.weeklyLeave ?? 0}',
                             style: TextStyle(
                               color: (leaveTypesResponse?.weeklyLeave ?? 0) == 0
                                   ? Colors.grey
                                   : Colors.black,
                             ),
                           ),
                         ],
                       ),

                       /// Leave Type
                       isHalfDay
                           ? DropdownButtonFormField<String>(
                         value: selectedHalfDayLeaveType,
                         items: getHalfDayLeaveTypes()
                             .map(
                               (e) => DropdownMenuItem(
                             value: e,
                             child: Text(e),
                           ),
                         )
                             .toList(),
                         onChanged: (v) {
                           setStateSheet(() {
                             selectedHalfDayLeaveType = v!;
                           });
                         },
                         decoration: const InputDecoration(
                           labelText: 'Select Half Day Leave Type',
                         ),
                       )
                           : weeklyLeave
                           ? DropdownButtonFormField<String>(
                         value: selectedWeeklyLeaveType,
                         items: weeklyLeaveTypes
                             .map(
                               (e) => DropdownMenuItem(
                             value: e,
                             child: Text(e),
                           ),
                         )
                             .toList(),
                         onChanged: (w) {
                           setStateSheet(() {
                             selectedWeeklyLeaveType = w!;
                           });
                         },
                         decoration: const InputDecoration(
                           labelText: 'Select Weekly Leave Type',
                         ),
                       )
                           : DropdownButtonFormField<String>(
                         value: selectedLeaveType,
                         items: getLeaveTypes()
                             .map<DropdownMenuItem<String>>(
                               (e) => DropdownMenuItem<String>(
                             value: e,
                             child: Text(e),
                           ),
                         )
                             .toList(),
                         onChanged: (v) {
                           setStateSheet(() {
                             selectedLeaveType = v!;
                           });
                         },
                         decoration: const InputDecoration(
                           labelText: 'Select Type of Leave',
                         ),
                       ),


                       if ((!isHalfDay && selectedLeaveType == 'Other') ||
                           (isHalfDay && selectedHalfDayLeaveType == 'Other'))
                         TextField(
                           controller: manualLeaveTypeController,
                           decoration: const InputDecoration(labelText: 'Enter Leave Type'),
                         ),

                       const SizedBox(height: 7),

                       /// Date Fields
                       isHalfDay || weeklyLeave
                           ? TextField(
                         controller: singleDateController,
                         readOnly: true,
                         decoration: const InputDecoration(
                           labelText: 'Select Date',
                           suffixIcon: Icon(Icons.calendar_today),
                         ),
                         onTap: () =>
                             _selectDate(context, singleDateController),
                       )
                           : Column(
                         children: [
                           TextField(
                             controller: startDateController,
                             readOnly: true,
                             decoration: const InputDecoration(
                               labelText: 'Start Date',
                               suffixIcon: Icon(Icons.calendar_today),
                             ),
                             onTap: () =>
                                 _selectDate(context, startDateController),
                           ),
                           const SizedBox(height: 14),
                           TextField(
                             controller: endDateController,
                             readOnly: true,
                             decoration: const InputDecoration(
                               labelText: 'End Date',
                               suffixIcon: Icon(Icons.calendar_today),
                             ),
                             onTap: () =>
                                 _selectDate(context, endDateController),
                           ),
                         ],
                       ),

                       const SizedBox(height: 7),

                       /// Shift Dropdown
                       if (isHalfDay)
                         DropdownButtonFormField<String>(
                           value: selectedShift,
                           items: shifts
                               .map((e) =>
                               DropdownMenuItem(value: e, child: Text(e)))
                               .toList(),
                           onChanged: (v) {
                             setStateSheet(() {
                               selectedShift = v!;
                             });
                           },
                           decoration:
                           const InputDecoration(labelText: 'Select Shift'),
                         ),

                       const SizedBox(height: 7),

                       TextField(
                           controller: reasonController,
                           //maxLines: 3,
                           decoration:
                           const InputDecoration(labelText: 'Reason')),

                       const SizedBox(height: 20),

                       Row(
                         children: [
                           Expanded(
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppColor.darkSkyBlue,
                               ),
                               onPressed: () {
                                 Navigator.pop(context);
                               },
                               child: const Text('Cancel',
                                   style: TextStyle(color: Colors.white)),
                             ),
                           ),

                           const SizedBox(width: 12),

                           Expanded(
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppColor.darkSkyBlue,
                               ),
                               onPressed: () async {

                                 final userId = await SessionManager.getUserId();
                                 final adminId = await SessionManager.getAdminAutoId();
                                 final appTypeId = await SessionManager.getAppTypeId();

                                 context.read<LeaveBloc>().add(
                                   ApplyLeaveEvent(
                                     userAutoId: userId!,
                                     adminAutoId: adminId!,
                                     appTypeId: appTypeId!,
                                     leaveType: isHalfDay
                                         ? selectedHalfDayLeaveType
                                         : selectedLeaveType == 'Other'
                                         ? manualLeaveTypeController.text
                                         : selectedLeaveType,
                                     startDate: isHalfDay
                                         ? singleDateController.text
                                         : startDateController.text,
                                     endDate: isHalfDay
                                         ? singleDateController.text
                                         : endDateController.text,
                                     isHalfDay: isHalfDay ? 'Yes' : 'No',
                                     shift: '',
                                     reason: reasonController.text,
                                     weeklyLeave: weeklyLeave ? 'yes' : 'No',
                                   ),
                                 );

                                 Navigator.pop(context);
                               },
                               child: const Text('Apply',
                                   style: TextStyle(color: Colors.white)),
                             ),
                           ),
                         ],
                       )
                     ]),
               ),
             );
           },
         );
       },
     );
   }

   void _showLeaveDetails(BuildContext context, LeaveModel leave) {
     showModalBottomSheet(
       context: context,
       backgroundColor: Colors.white,
       builder: (_) => Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
           children: [

             const Text(
               'Leave Details',
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
             ),

             const Divider(),

             Text('Leave Type: ${leave.leaveType}'),

             /// Date Logic
             leave.isHalfDay == 'Yes'
                 ? Text('Date: ${leave.startDate}')
                 : Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('Start Date: ${leave.startDate}'),
                 Text('End Date: ${leave.endDate}'),
               ],
             ),

             Text('Reason: ${leave.reason}'),

             Text('Half Day: ${leave.isHalfDay}'),
             if (leave.isHalfDay == 'Yes')
               Text('Shift: ${leave.shift}'),

             Text('Status: ${leave.status}'),
             //Text('Weekly Leave: ${leave.weeklyLeave}'),
           ],
         ),
       ),
     );
   }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
