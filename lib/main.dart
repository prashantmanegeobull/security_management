import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:security_management/routes/app_pages.dart';
import 'package:security_management/routes/app_routes.dart';

import 'core/theme/app_theme.dart';
import 'features/DashBoard/View/dashboard_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // adjust if your design uses another size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Security Management",
          theme: AppTheme.lightTheme,

          initialRoute: AppRoutes.dashboard,
          getPages: AppPages.routes,
        );
      },
    );
  }
}