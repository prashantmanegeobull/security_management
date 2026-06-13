class ShiftModel {
  final String shiftName;
  final String startTime;
  final String endTime;
  final String siteName;
  final String status;
  final bool showBadge;

  ShiftModel({
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.siteName,
    required this.status,
    required this.showBadge,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      shiftName: json['shift_name'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      siteName: json['site_name'] ?? '',
      status: json['status'] ?? '',
      showBadge: json['show_badge'] ?? false,
    );
  }
}