
import '../../../core/model/shift_model.dart';

class ShiftService {
  Future<Map<String, List<ShiftModel>>> getShifts() async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      "current": [
        ShiftModel(
          shiftName: "Morning Shift",
          startTime: "8:00 AM",
          endTime: "8:00 PM",
          siteName: "Site A - Green Valley Society",
          status: "Started",
          showBadge: true,
        ),
        ShiftModel(
          shiftName: "Evening Shift",
          startTime: "8:00 PM",
          endTime: "8:00 AM",
          siteName: "Site B - Silver Heights",
          status: "Tomorrow",
          showBadge: false,
        ),
        ShiftModel(
          shiftName: "Night Shift",
          startTime: "8:00 PM",
          endTime: "8:00 AM",
          siteName: "Site C - Blue Tower",
          status: "10 May 2024",
          showBadge: false,
        ),
      ],
      "upcoming": [

      ],
    };
  }
}