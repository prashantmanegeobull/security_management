import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/mark_attendance_controller.dart';

class MarkAttendanceScreen extends StatelessWidget {

  MarkAttendanceScreen({super.key});

  final controller =
  Get.find<MarkAttendanceController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
        const Text(
          "Mark Attendance",
        ),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Obx(
              () => Column(

            children: [

              GestureDetector(

                onTap:
                controller
                    .captureSelfie,

                child: Container(

                  height: 250,

                  width:
                  double.infinity,

                  decoration:
                  BoxDecoration(
                    border:
                    Border.all(),
                    borderRadius:
                    BorderRadius.circular(
                        12),
                  ),

                  child:
                  controller
                      .selfieFile
                      .value ==
                      null
                      ? const Center(
                    child: Text(
                      "Tap To Capture Selfie",
                    ),
                  )
                      : Image.file(
                    File(
                      controller
                          .selfieFile
                          .value!
                          .path,
                    ),
                    fit:
                    BoxFit.cover,
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(

                width:
                double.infinity,

                child:
                ElevatedButton(

                  onPressed:
                  controller
                      .isSubmitting
                      .value
                      ? null
                      : controller
                      .submitAttendance,

                  child:
                  controller
                      .isSubmitting
                      .value
                      ? const CircularProgressIndicator()
                      : const Text(
                    "Submit Attendance",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}