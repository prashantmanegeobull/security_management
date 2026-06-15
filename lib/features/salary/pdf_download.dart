import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

import '../../core/model/profile_model.dart';
import '../../core/model/salary_model.dart';


class PayslipPdfService {

  static pw.Widget _cell(
      String text, {
        bool bold = false,
        pw.Alignment align = pw.Alignment.centerLeft,
        pw.Font? font, // add font parameter
      }) {
    return pw.Container(
      alignment: align,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font, // use the TTF font
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.TableRow _row(List<String> cells, {bool bold = false, pw.Font? font}) {
    return pw.TableRow(
      children: cells.map((e) => _cell(e, bold: bold, font: font)).toList(),
    );
  }



  static Future<File> generatePayslipPdf({
    required UserProfile profile,
    required SalaryMonth monthData,
    required SalaryResponse salaryResponse,
  }) async {

    final pdf = pw.Document();
    // final font = pw.Font.ttf(
    //     await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));

    final date = DateTime.parse("${monthData.month}-01");
    final formattedMonth =
    DateFormat('MMMM yyyy').format(date).toUpperCase();

    final basic = salaryResponse.baseSalary;
    final deduction = monthData.deduction;
    final netSalary = basic - deduction;
    final tds = basic * 0.10;
    final otherAllowances =
    basic - basic;


    final totalDays =
    DateUtils.getDaysInMonth(date.year, date.month);

    final leaves = monthData.approvedLeaves;
    final paidDays = totalDays - leaves;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [

              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "MD HOME FINANCE",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "OFFICE 103 , SAI GOVIND BHUVAN MATHURADAS ROAD , KANDIVALI WEST 400067",
                  textAlign: pw.TextAlign.center,
                ),
              ),

              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  "Pay Slip for $formattedMonth",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),

              //pw.SizedBox(height: 10),

              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.6),
                  1: pw.FlexColumnWidth(1.2),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                },
                children: [
                  _row(["Name of the Employee", profile.name, "Bank Name", "Testing"] ),
                  _row(["Designation", profile.userType, "Bank A/C No", "Testing"] ),
                  _row(["Department", "Sales", "", ""] ),
                  _row(["Total Working Days", "$totalDays", "Paid Days", "$paidDays"]),
                  _row(["LOP Days", "0", "Leaves Taken", "$leaves"] ),
                ],
              ),

              //pw.SizedBox(height: 10),

               pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  _row(["Earnings", "Deductions"], bold: true),
                ],
              ),

              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  _row(["Basic Wage", "${basic.toStringAsFixed(2) }", "TDS 10%", "${tds.toStringAsFixed(2)}"] ),
                  _row(["Other Allowances", "${otherAllowances.toStringAsFixed(2)}", "", ""]),
                  _row(["Total Earnings", "${basic.toStringAsFixed(2)}", "Total Deductions", "${deduction.toStringAsFixed(2)}"], bold: true),
                ],
              ),

              //pw.SizedBox(height: 10),

               pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  _row(["Net Salary", "${netSalary.toStringAsFixed(2)}"], bold: true),
                ],
              ),


              pw.SizedBox(height: 40),



               pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Employer Signature"),
                  pw.Text("Employee Signature"),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final bytes = await pdf.save();

    Directory dir;

    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final file =
    File('${dir.path}/PaySlip_${monthData.month}.pdf');

    await file.writeAsBytes(bytes);

    return file;
  }
}