import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:security_management/core/bindings/apply_leave_binding.dart';
import 'package:security_management/features/ApplyLeaves/screen/apply_leave_screen.dart';
import 'package:security_management/features/my_leaves/screens/leave_screen.dart';
import 'package:security_management/features/shift/screen/my_sites_screen.dart';

import 'core/bindings/leave_binding.dart';
import 'core/bindings/shift_binding.dart';
import 'core/theme/app_theme.dart';
import 'features/shift/screen/shift_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Shift Management',

      initialRoute: '/leaves',

      getPages: [
        GetPage(
          name: '/shift',
          page: () =>  ShiftScreen(),
          binding: ShiftBinding(),
        ),

        GetPage(name: '/sites',
            page: ()=> MySitesScreen(),
            binding: ShiftBinding()),

        GetPage(name: '/leaves',
            page: ()=>LeaveScreen(),
            binding: LeaveBinding()),


        GetPage(name: '/apply-leave',
            page: ()=>ApplyLeaveScreen(),
            binding: ApplyLeaveBinding()),
      ],

      theme: AppTheme.lightTheme,

    );
  }
}

