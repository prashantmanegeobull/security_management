class MyLeaveModel {
  final int id;
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String status;

  MyLeaveModel({
    required this.id,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });

  factory MyLeaveModel.fromJson(Map<String, dynamic> json) {
    return MyLeaveModel(
      id: json['id'] ?? 0,
      leaveType: json['leaveType'] ?? '',
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leaveType': leaveType,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'status': status,
    };
  }
}