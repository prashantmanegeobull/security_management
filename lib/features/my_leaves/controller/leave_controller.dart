import 'package:get/get.dart';
import '../../core/model/leave_model.dart';

class LeaveController extends GetxController {

  final RxInt selectedTab = 0.obs;

  final RxList<LeaveModel> leaveList = <LeaveModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    leaveList.addAll([
      LeaveModel(
        id: 1,
        leaveType: 'Casual Leave',
        fromDate: DateTime(2026, 6, 10),
        toDate: DateTime(2026, 6, 10),
        status: 'Approved',
      ),
      LeaveModel(
        id: 2,
        leaveType: 'Sick Leave',
        fromDate: DateTime(2026, 6, 12),
        toDate: DateTime(2026, 6, 13),
        status: 'Pending',
      ),
      LeaveModel(
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

    List<LeaveModel> get filteredLeaves {
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
