import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../core/Helper/ApiString.dart';
import '../../core/model/profile_model.dart';
import '../../core/model/salary_model.dart';



class PaySlipUI extends StatefulWidget {
  final String userAutoId;
  final SalaryMonth monthData;
  final SalaryResponse salaryResponse;

  const PaySlipUI({
    super.key,
    required this.userAutoId,
    required this.monthData,
    required this.salaryResponse,
  });

  @override
  State<PaySlipUI> createState() => _PaySlipUIState();
}

class _PaySlipUIState extends State<PaySlipUI> {
  UserProfile? profile;

  @override
  void initState() {
    super.initState();
    fetchProfile(widget.userAutoId);
  }


  double get basic => widget.salaryResponse.baseSalary;

  double get deduction => widget.monthData.deduction;

  double get totalEarnings => basic;

  double get totalDeductions => deduction;

   double get netSalary => totalEarnings - totalDeductions;

   String get formattedMonth {
    final date = DateTime.parse("${widget.monthData.month}-01");
    return DateFormat('MMMM yyyy').format(date).toUpperCase();
  }


  Future<void> fetchProfile(String userAutoId) async {
    try {
      final result = await getProfile(userAutoId);
      if (mounted) {
        setState(() => profile = result);
      }
    } catch (_) {}
  }

  Future<UserProfile> getProfile(String userAutoId) async {
    final response = await http.post(
      Uri.parse(ApiString.userProfile),
      body: {"user_auto_id": userAutoId},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 1) {
      return UserProfile.fromJson(data['profile']);
    } else {
      throw Exception("Failed to load profile");
    }
  }


  Widget cell(
      String text,
      {bool bold = false, Alignment align = Alignment.centerLeft}) {
    return Container(
      alignment: align,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  TableRow row(List<String> cells, {bool bold = false}) {
    return TableRow(children: cells.map((e) => cell(e, bold: bold)).toList());
  }

  int get totalWorkingDays {
    final date = DateTime.parse("${widget.monthData.month}-01");
    return DateUtils.getDaysInMonth(date.year, date.month);
  }

  int get leavesTaken => widget.monthData.approvedLeaves;

  int get lopDays => 0;

  int get paidDays => totalWorkingDays - leavesTaken - lopDays;

  double get otherAllowances =>
      totalEarnings - basic;

  double get tds => totalEarnings * 0.10;



  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
    padding: const EdgeInsets.all(10),
      child:Center(
        child: AspectRatio(
          aspectRatio: 1 / 1.200,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                 Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      cell("MD HOME FINANCE",
                          bold: true, align: Alignment.center),
                    ]),
                  ],
                ),

                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      cell(
                        "OFFICE 103 , SAI GOVIND BHUVAN MATHURADAS ROAD , KANDIVALI WEST 400067",
                        align: Alignment.center,
                      ),
                    ]),
                  ],
                ),

                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      cell("Pay Slip for $formattedMonth",
                          align: Alignment.center),
                    ]),
                  ],
                ),

                 Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(1.6),
                    1: FlexColumnWidth(1.2),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    row([" ", "", " ", ""]),
                    row(["Name of the Employee", profile!.name, "Bank Name", "Testing"]),
                    row(["Designation", profile!.userType, "Bank A/C No", "Testing"]),
                    row(["Department", "Sales", "", ""]),
                    row(["Total Working Days", totalWorkingDays.toString(), "Paid Days", paidDays.toString()]),
                    row(["LOP Days", lopDays.toString(), "Leaves Taken", leavesTaken.toString()]),
                  ],
                ),

                Table(border: TableBorder.all(color: Colors.black), children: [
                  row([""])
                ]),

                 Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    row(["Earnings", "Deductions"], bold: true),
                  ],
                ),

                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(1.5),
                    1: FlexColumnWidth(1.2),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.2),
                  },
                  children: [

                    row([
                      "Basic Wage",
                      "₹${basic.toStringAsFixed(2)}",
                      "TDS (10%)",
                      "₹${tds.toStringAsFixed(2)}"
                    ]),

                    row([
                      "Other Allowances",
                      "₹${otherAllowances.toStringAsFixed(2)}",
                      "",
                      ""
                    ]),

                    row([
                      "Total Earnings",
                      "₹${totalEarnings.toStringAsFixed(2)}",
                      "Total Deductions",
                      "₹${totalDeductions.toStringAsFixed(2)}"
                    ], bold: true),
                  ],
                ),

                 Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(3.5),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    row(
                      ["Net Salary", "₹${netSalary.toStringAsFixed(2)}"],
                      bold: true,
                    ),
                  ],
                ),

                const Spacer(),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      children: [
                        SizedBox(width: 150, child: Divider(color: Colors.black)),
                        Text("Employer Signature",
                            style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(width: 150, child: Divider(color: Colors.black)),
                        Text("Employee Signature",
                            style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}