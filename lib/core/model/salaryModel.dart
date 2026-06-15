 class SalaryModel {
  final String month;
  final String netSalary;
  final String attendance;
  final int leaves;
  final bool targetsMet;
  final DateTime date;

  SalaryModel({
    required this.month,
    required this.netSalary,
    required this.attendance,
    required this.leaves,
    required this.targetsMet,
    required this.date,
  });

}