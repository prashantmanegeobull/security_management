class ShiftModel {
  final String id;

  final String shiftName;
  final String shiftDate;

  final String startTime;
  final String endTime;

  final String siteCode;
  final String siteName;
  final String siteAddress;
  final String siteRadius;

  final String status;

  final double latitude;
  final double longitude;

  final bool showBadge;

  ShiftModel({
    required this.id,
    required this.shiftName,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.siteCode,
    required this.siteName,
    required this.siteAddress,
    required this.siteRadius,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.showBadge,
  });

  factory ShiftModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShiftModel(
      id: json['id']?.toString() ?? '',

      shiftName:
      json['shift_name'] ?? '',

      shiftDate:
      json['shift_date'] ?? '',

      startTime:
      json['start_time'] ?? '',

      endTime:
      json['end_time'] ?? '',

      siteCode:
      json['site_code'] ?? '',

      siteName:
      json['site_name'] ?? '',

      siteAddress:
      json['site_address'] ?? '',

      siteRadius:
      json['site_radius'] ?? '',

      status:
      json['status'] ?? '',

      latitude:
      double.tryParse(
        json['latitude']
            ?.toString() ??
            '',
      ) ??
          0.0,

      longitude:
      double.tryParse(
        json['longitude']
            ?.toString() ??
            '',
      ) ??
          0.0,

      showBadge:
      json['show_badge'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shift_name': shiftName,
      'shift_date': shiftDate,
      'start_time': startTime,
      'end_time': endTime,
      'site_code': siteCode,
      'site_name': siteName,
      'site_address': siteAddress,
      'site_radius': siteRadius,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'show_badge': showBadge,
    };
  }
}