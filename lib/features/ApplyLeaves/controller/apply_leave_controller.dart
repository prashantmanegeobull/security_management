import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ApplyLeaveController extends GetxController {

  var selectedLeaveType=''.obs;
  final reasonController=TextEditingController();

  var fromDate=Rxn<DateTime>();
  var toDate=Rxn<DateTime>();

  var isLoading=false.obs;

  var reason=''.obs;

  var selectedFilePath=''.obs;
  var selectedFileName=''.obs;


  void setLeaveType(String value){
    selectedLeaveType.value=value;
  }

  void setFromDate(DateTime date){
    fromDate.value=date;
  }

  void setToDate(DateTime date){
    toDate.value=date;
  }

  void setReason(String value){
    reason.value=value;
  }

  void setFile({
    required String name, String? path,
  }){
    selectedFilePath.value=name;
    selectedFileName.value=path ?? '';
  }


  void clearForm(){
    selectedLeaveType.value='';
    fromDate.value=null;
    toDate.value=null;
    reason.value='';
    selectedFilePath.value='';
    selectedFileName.value='';

    reasonController.clear();
  }
  void submitLeave(){
    if(selectedLeaveType.value.isEmpty){
      Get.snackbar("Error", "Please select leave type",
      );
      return;
    }

    if(fromDate.value==null){
      Get.snackbar("Error",
        "Please Enter from date",
      );
      return;
    }
    if(toDate.value==null){
      Get.snackbar("Error",
        "Please Enter to date",
      );
      return;
    }

    if(reason.value.trim().isEmpty){
      Get.snackbar("Error",
        "Please enter reason",
      );
      return;
    }

    if(toDate.value!.isBefore(fromDate.value!)){
      Get.snackbar("Error",
        "To Date cannot be before From Date",
      );
      return;
    }


    print("Leave Type : ${selectedLeaveType.value}");
    print("From:${fromDate.value}");
    print("To: ${toDate.value}");
    print("Reason: ${reason.value}");
    print("File: ${selectedFileName.value}");


    Get.snackbar("Suceess", "Leave applied successfully",
    );


    clearForm();
  }



}


