
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/leave_controller.dart';
import '../widgets/leave_card.dart';

class LeaveScreen extends StatelessWidget {
  LeaveScreen({super.key});

  final LeaveController controller = Get.find<LeaveController>();

  final List<String> tabs = const [
    'All',
    'Pending',
    'Approved',
    'Rejected',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Leaves',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [

          /// ---------------- TABS ----------------
          SizedBox(
            height: 50,
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  tabs.length,
                      (index) {
                    final isSelected =
                        controller.selectedTab.value == index;

                    return GestureDetector(
                      onTap: () {
                        controller.changeTab(index);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 6),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 2,
                            width: 40,
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),

          const Divider(height: 1),

          /// ---------------- LIST ----------------
          Expanded(
            child: Obx(() {
              final leaves = controller.filteredLeaves;

              if (leaves.isEmpty) {
                return const Center(
                  child: Text('No Leaves Found'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: leaves.length,
                itemBuilder: (context, index) {
                  return LeaveCard(
                    leave: leaves[index],
                  );
                },
              );
            }),
          ),
        ],
      ),

      /// ---------------- BUTTON ----------------
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Apply Leave Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Apply Leave',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}