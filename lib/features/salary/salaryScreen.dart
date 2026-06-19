// salary_screen.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:security_management/features/salary/pdf_download.dart';

import '../../core/Helper/ApiString.dart';
import '../../core/Helper/commonDecoration.dart';
import '../../core/Helper/session_manager.dart';
import '../../core/model/profile_model.dart';
import '../../core/model/salaryModel.dart';
import '../../core/model/salary_model.dart';
import '../../core/theme/app_colors2.dart';
import 'Bloc/salary_bloc.dart';
import 'Bloc/salary_event.dart';
import 'Bloc/salary_state.dart';
import 'invoice.dart';

class SalaryTab extends StatefulWidget {
  const SalaryTab({super.key});

  @override
  State<SalaryTab> createState() => _SalaryTabState();
}

class _SalaryTabState extends State<SalaryTab> {
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

   Future<void> _fetchSalary() async {
    if (_filterStartDate == null || _filterEndDate == null) return;

    final userAutoId = await SessionManager.getUserIdOrThrow();

    context.read<SalaryBloc>().add(
      FetchSalaryEvent(
        userAutoId: userAutoId,
        startMonth: DateFormat('yyyy-MM').format(_filterStartDate!),
        endMonth: DateFormat('yyyy-MM').format(_filterEndDate!),
      ),
    );
  }

  Future<void> _pickMonth() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
         _filterStartDate = DateTime(picked.year, picked.month, 1);

         _filterEndDate = DateTime(picked.year, picked.month + 1, 0);
      });

      _fetchSalary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             GestureDetector(
              onTap: _pickMonth,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      _filterStartDate == null
                          ? "Select Month & Year"
                          : "${_filterStartDate!.year}-${_filterStartDate!.month.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

             BlocBuilder<SalaryBloc, SalaryState>(
              builder: (context, state) {
                if (state is SalaryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SalaryError) {
                  return Center(child: Text(state.message));
                }

                if (state is SalaryLoaded) {
                  // Map API SalaryMonth → UI SalaryModel
                  final salaryList = state.response.months.map((month) {
                    return SalaryModel(
                      month: month.month,
                      netSalary: month.finalSalary.toStringAsFixed(2),
                      attendance: month.halfDays.toString(),
                      leaves: month.approvedLeaves,
                      targetsMet: true,
                      date: DateTime.now(),
                    );
                  }).toList();

                  if (salaryList.isEmpty) {
                    return const Center(child: Text('No salary data found'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: salaryList.length,
                    itemBuilder: (context, index) {
                      final slip = salaryList[index];

                       final month = state.response.months[index];

                      return GestureDetector(
                        onTap: () async {
                          final userAutoId = await SessionManager.getUserIdOrThrow();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaySlipUI(
                                userAutoId: userAutoId,
                                monthData: month,
                                salaryResponse: state.response,
                              ),
                            ),
                          );
                        },
                        child: _salaryCard(slip, month, state.response),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _salaryCard(
      SalaryModel slip,
      SalaryMonth monthData,
      SalaryResponse response,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: CommonDecorations.boxDecoration(
        borderRadius: 10,
        backgroundColor: AppColor.whiteColor,
        borderColor: Colors.grey.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slip.month,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Net Salary: ${slip.netSalary}'),
                  const SizedBox(height: 4),
                  Text('Attendance: ${slip.attendance} | Leaves: ${slip.leaves}'),
                  const SizedBox(height: 4),
                  Text(
                    'Targets Met: ${slip.targetsMet ? 'Yes' : 'No'}',
                    style: TextStyle(
                      color: slip.targetsMet ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

             GestureDetector(
              onTap: () async {

                final userAutoId =
                await SessionManager.getUserIdOrThrow();

                final profile = await getProfile(userAutoId);

                final file = await PayslipPdfService.generatePayslipPdf(
                  profile: profile,
                  monthData: monthData,
                  salaryResponse: response,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Saved to ${file.path}')),
                );
              },
              child: const Icon(Icons.download, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
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



class SalarySlipDetail extends StatelessWidget {
  final SalaryModel slip;

  const SalarySlipDetail({super.key, required this.slip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salary Slip')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoRow('Month', slip.month),
            _infoRow('Net Salary', slip.netSalary),
            _infoRow('Attendance', slip.attendance),
            _infoRow('Leaves', slip.leaves.toString()),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}