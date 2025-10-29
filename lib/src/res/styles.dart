import 'package:algon_mobile/src/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  const AppStyles._();

  static TextStyle textStyle = const TextStyle(
    fontSize: 16,
    color: AppColors.blackColor,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.0,
  );
  static InputDecoration inputDecoration = const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 8));
}
