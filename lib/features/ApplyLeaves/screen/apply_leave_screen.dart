import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:security_management/features/ApplyLeaves/controller/apply_leave_controller.dart';


class ApplyLeaveScreen  extends StatefulWidget{
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState()=> _ApplyLeaveScreenState();


}
class _ApplyLeaveScreenState extends State<ApplyLeaveScreen>{

  final controller=Get.put(ApplyLeaveController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Apply Leave"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(padding:
        EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Apply Leave",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),


              const Text("Leave Type",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedLeaveType.value.isEmpty
                          ? null
                          : controller.selectedLeaveType.value,

                      hint: const Text("Select Leave Type"),

                      isExpanded: true,

                      items: const [
                        "Casual Leave",
                        "Sick Leave",
                        "Emergency Leave",
                      ].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),

                      onChanged: (value) {
                        if (value != null) {
                          controller.setLeaveType(value);
                        }
                      },
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              const Text("From Date", style: TextStyle(fontWeight: FontWeight.w600),

              ),

              Obx(() {
                return TextField(
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );

                    if (pickedDate != null) {
                      controller.setFromDate(pickedDate);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Select Date",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_month),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );

                        if (pickedDate != null) {
                          controller.setFromDate(pickedDate);
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: controller.fromDate.value == null
                        ? ""
                        : controller.fromDate.value.toString().split(" ")[0],
                  ),
                );
              }),
              const SizedBox(height: 20),

              const Text(
                "To Date",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Obx(() {
                return TextField(
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );

                    if (pickedDate != null) {
                      controller.setToDate(pickedDate);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Select Date",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_month),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );

                        if (pickedDate != null) {
                          controller.setToDate(pickedDate);
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: controller.toDate.value == null
                        ? ""
                        : controller.toDate.value.toString().split(" ")[0],
                  ),
                );
              }),

              const SizedBox(height: 20),

              const Text("Reason",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: controller.reasonController,
                maxLines: 3,
                onChanged: (value){
                  controller.setReason(value);
                },
                decoration:  InputDecoration(
                  hintText: "Enter reason for leave",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Attach Document",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              Obx((){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(onTap: () async{
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles();

                      if (result != null) {
                        PlatformFile file = result.files.first;
                        controller.selectedFileName.value = file.name;

                        if (file.path != null) {
                          controller.selectedFilePath.value = file.path!;
                        }
                      }
                    },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_file),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                controller.selectedFileName.value.isEmpty ? "Choose File"
                                    : controller.selectedFileName.value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (controller.selectedFileName.value.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "File selected successfully",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              }),


              const SizedBox(height: 30),

              Obx((){
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(onPressed: controller.isLoading.value?null:(){
                    controller.submitLeave();

                  }, child: controller.isLoading.value
                      ?const CircularProgressIndicator(
                    color: Colors.white,
                  ): const Text("Submit Leave"),
                  ),
                );
              }),

            ],
          ),
        ),
      ),
    );

  }

}