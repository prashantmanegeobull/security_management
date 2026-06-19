

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../core/model/my_leave_model.dart';


class LeaveController extends GetxController {

  final RxInt selectedTab = 0.obs;

  final RxList<MyLeaveModel> leaveList = <MyLeaveModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    leaveList.addAll([
      MyLeaveModel(
        id: 1,
        leaveType: 'Casual Leave',
        fromDate: DateTime(2026, 6, 10),
        toDate: DateTime(2026, 6, 10),
        status: 'Approved',
      ),
      MyLeaveModel(
        id: 2,
        leaveType: 'Sick Leave',
        fromDate: DateTime(2026, 6, 12),
        toDate: DateTime(2026, 6, 13),
        status: 'Pending',
      ),
      MyLeaveModel(
        id: 3,
        leaveType: 'Emergency Leave',
        fromDate: DateTime(2026, 6, 15),
        toDate: DateTime(2026, 6, 15),
        status: 'Rejected',
      ),
    ]);
  }

    void changeTab(int index){
    selectedTab.value=index;
    }

    List<MyLeaveModel> get filteredLeaves {
      switch (selectedTab.value) {
        case 1:
          return leaveList.where((leave) => leave.status.toLowerCase() == 'pending').toList();

        case 2:
          return leaveList
              .where((leave) => leave.status.toLowerCase() == 'approved')
              .toList();

        case 3:
          return leaveList
              .where((leave) => leave.status.toLowerCase() == 'rejected')
              .toList();


        default:
          return leaveList;
      }
    }


    }
