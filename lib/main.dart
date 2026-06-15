import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:security_management/features/shift/screen/my_sites_screen.dart';
=======
import 'core/theme/app_theme.dart';
import 'features/DashBoard/View/dashboard_view.dart';
>>>>>>> origin/dashboard_ui

import 'core/bindings/shift_binding.dart';
import 'core/theme/app_theme.dart';
import 'features/shift/screen/shift_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

<<<<<<< HEAD
      title: 'Shift Management',

      initialRoute: '/sites',

      getPages: [
        GetPage(
          name: '/shift',
          page: () =>  ShiftScreen(),
          binding: ShiftBinding(),
        ),

        GetPage(name: '/sites', page: ()=> MySitesScreen(),binding: ShiftBinding())
      ],

      theme: AppTheme.lightTheme,

    );
  }
}

=======
      title: "Security Management",

      theme: AppTheme.lightTheme,

      home:DashboardView(),
    );
  }
}
>>>>>>> origin/dashboard_ui
