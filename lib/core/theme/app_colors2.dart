import 'package:flutter/material.dart';

class AppColor {

  static const Color darkSkyBlue = Color(0xFF3F63F7);
  static const Color lightSkyBlue = Color(0xFFE2EFFF);
  static const Color lightblue =  Color(0xFF8CA1FA);
  static const Color blue = Colors.blue;
  static const Color greyColor = Colors.grey;
  static const Color TextGreyColor = Colors.black54;
  static const Color whiteColor = Colors.white;
  static const Color greenColor = Colors.green;
  static const Color blackColor = Colors.black54;
  static const Color DarkblackColor = Colors.black87;
  static const Color appBGcolor = Color(0xFFF1F1F9);


  static Color fromHex(
      String hexString,
      ) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write(
        'ff',
      );
    }
    buffer.write(
      hexString.replaceFirst(
        '#',
        '',
      ),
    );
    return Color(
      int.parse(
        buffer.toString(),
        radix: 16,
      ),
    );
  }
}