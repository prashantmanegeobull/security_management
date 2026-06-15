import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:security_management/features/shift/screen/my_sites_screen.dart';

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

