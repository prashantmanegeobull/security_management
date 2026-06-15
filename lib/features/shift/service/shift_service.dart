import '../../../core/model/shift_model.dart';

class ShiftService {
  Future<Map<String, List<ShiftModel>>>
  getShifts() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    return {
      "current": [
        ShiftModel(
          id: "1",

          shiftName:
          "Morning Shift",

          shiftDate:
          "8 May 2024",

          startTime:
          "8:00 AM",

          endTime:
          "8:00 PM",

          siteCode:
          "Site A",

          siteName:
          "Green Valley Society",

          siteAddress:
          "123, Green Valley Road,\nBangalore - 560001",

          siteRadius:
          "100 Meter",

          status:
          "Started",

          latitude:
          12.9716,

          longitude:
          77.5946,

          showBadge:
          true, isActive: true,
        ),

        ShiftModel(
          id: "2",

          shiftName:
          "Evening Shift",

          shiftDate:
          "9 May 2024",

          startTime:
          "8:00 PM",

          endTime:
          "8:00 AM",

          siteCode:
          "Site B",

          siteName:
          "Silver Heights",

          siteAddress:
          "45, MG Road,\nBangalore - 560002",

          siteRadius:
          "150 Meter",

          status:
          "Tomorrow",

          latitude:
          12.9750,

          longitude:
          77.5990,

          showBadge:
          false, isActive: true,
        ),

        ShiftModel(
          id: "3",

          shiftName:
          "Night Shift",

          shiftDate:
          "10 May 2024",

          startTime:
          "8:00 PM",

          endTime:
          "8:00 AM",

          siteCode:
          "Site C",

          siteName:
          "Blue Tower",

          siteAddress:
          "78, Residency Road,\nBangalore - 560025",

          siteRadius:
          "120 Meter",

          status:
          "10 May 2024",

          latitude:
          12.9660,

          longitude:
          77.6010,

          showBadge:
          false, isActive: true,
        ),
      ],

      "upcoming": [
        ShiftModel(
          id: "4",

          shiftName:
          "Day Shift",

          shiftDate:
          "12 May 2024",

          startTime:
          "9:00 AM",

          endTime:
          "6:00 PM",

          siteCode:
          "Site D",

          siteName:
          "Sky Residency",

          siteAddress:
          "21, Whitefield Main Road,\nBangalore - 560066",

          siteRadius:
          "100 Meter",

          status:
          "Upcoming",

          latitude:
          12.9698,

          longitude:
          77.7500,

          showBadge:
          false, isActive: true,
        ),
      ],
    };
  }
}