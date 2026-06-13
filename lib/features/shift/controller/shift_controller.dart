import 'package:get/get.dart';

import '../../../core/model/shift_model.dart';
import '../service/shift_service.dart';


class ShiftController extends GetxController {
  final service = ShiftService();

  RxBool isLoading = false.obs;

  RxList<ShiftModel> currentShifts =
      <ShiftModel>[].obs;

  RxList<ShiftModel> upcomingShifts =
      <ShiftModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("Controller Initialized");
    getShifts();

  }

  Future<void> getShifts() async {
    isLoading.value = true;

    try {
      final response = await service.getShifts();

      currentShifts.assignAll(
        response["current"] ?? [],
      );

      upcomingShifts.assignAll(
        response["upcoming"] ?? [],
      );
    } finally {
      isLoading.value = false;
    }
  }
}