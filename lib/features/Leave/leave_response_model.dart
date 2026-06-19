import '../../core/model/leave_model.dart';

class LeaveResponse {
  final int status;
  final String msg;
  final LeaveSummary summary;
  final List<LeaveModel> leaves;

  LeaveResponse({
    required this.status,
    required this.msg,
    required this.summary,
    required this.leaves,
  });

  factory LeaveResponse.fromJson(Map<String, dynamic> json) {
    return LeaveResponse(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? '',
      summary: LeaveSummary.fromJson(json['leave_summary'] ?? {}),
      leaves: (json['data'] as List? ?? [])
          .map((e) => LeaveModel.fromJson(e))
          .toList(),
    );
  }
}

class LeaveSummary {
  final int yearlyQuota;
  final int yearlyTaken;
  final int remainingLeaves;
  final int unpaidLeaves;

  LeaveSummary({
    required this.yearlyQuota,
    required this.yearlyTaken,
    required this.remainingLeaves,
    required this.unpaidLeaves,
  });

  factory LeaveSummary.fromJson(Map<String, dynamic> json) {
    return LeaveSummary(
      yearlyQuota: json['yearly_quota'] ?? 0,
      yearlyTaken: json['yearly_taken'] ?? 0,
      remainingLeaves: json['remaining_leaves'] ?? 0,
      unpaidLeaves: json['unpaid_leaves'] ?? 0,
    );
  }
}