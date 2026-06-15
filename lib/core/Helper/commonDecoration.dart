import 'package:flutter/material.dart';

class CommonDecorations {
  static BoxDecoration boxDecoration({
    double borderRadius = 12,
    Color backgroundColor = Colors.white,
    Color borderColor = Colors.transparent,
    double borderWidth = 1,
    BorderRadius? customBorderRadius,  // new optional param
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}
