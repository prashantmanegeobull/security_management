import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/model/shift_model.dart';
import '../controller/gps_attendance_controller.dart';

class AttendanceAlertDialog extends StatelessWidget {

  final ShiftModel shift;
  final double distance;

  const AttendanceAlertDialog({
    super.key,
    required this.shift,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      title: const Text(
        "Attendance Required",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("You entered ${shift.siteName}"),

          const SizedBox(height: 12),

          Text("Distance: ${distance.toStringAsFixed(2)} m"),
        ],
      ),

      actions: [

        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.toNamed('/mark-attendance');
          },
          child: const Text("Mark Attendance"),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              Get.find<GpsAttendanceController>()
                  .popupDismissed
                  .value = true;

              Get.back();
            },
            child: const Text("Cancel"),
          ),
        ),
      ],
    );
  }
}