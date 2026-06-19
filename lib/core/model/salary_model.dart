class SalaryResponse {
  final int status;
  final double baseSalary;
  final double perDaySalary;
  final double totalDeduction;
  final double totalFinalSalary;
  final List<SalaryMonth> months;

  SalaryResponse({
    required this.status,
    required this.baseSalary,
    required this.perDaySalary,
    required this.totalDeduction,
    required this.totalFinalSalary,
    required this.months,
  });

  factory SalaryResponse.fromJson(Map<String, dynamic> json) {
    return SalaryResponse(
      status: json['status'] ?? 0,
      baseSalary: (json['base_salary'] ?? 0).toDouble(),
      perDaySalary: (json['per_day_salary'] ?? 0).toDouble(),
      totalDeduction: (json['total_deduction'] ?? 0).toDouble(),
      totalFinalSalary: (json['total_final_salary'] ?? 0).toDouble(),
      months: (json['data'] as List? ?? [])
          .map((e) => SalaryMonth.fromJson(e))
          .toList(),
    );
  }
}

class SalaryMonth {
  final String month;
  final int halfDays;
  final int approvedLeaves;
  final double deduction;
  final double finalSalary;

  SalaryMonth({
    required this.month,
    required this.halfDays,
    required this.approvedLeaves,
    required this.deduction,
    required this.finalSalary,
  });

  factory SalaryMonth.fromJson(Map<String, dynamic> json) {
    return SalaryMonth(
      month: json['month'] ?? '',
      halfDays: json['half_days'] ?? 0,
      approvedLeaves: json['approved_leaves'] ?? 0,
      deduction: (json['deduction'] ?? 0).toDouble(),
      finalSalary: (json['final_salary'] ?? 0).toDouble(),
    );
  }
}