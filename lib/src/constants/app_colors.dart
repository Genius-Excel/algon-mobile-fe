import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color primaryTextColor = Color(0xff1A1C29);
  static const Color greyDark = Color(0xff676D81);
  static const Color primaryColor = Color(0xff6666FF);
  static const Color blackColor = Color(0xff0D0D0D);
  static const Color secondaryTextColor = Color.fromRGBO(103, 109, 129, 1);
  static const Color gradientStart = Color(0xFF065F46);
  static const Color gradientEnd = Color(0xFF10B981);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color errorColor = Color(0xffEF4444);
  static const Color green = Color(0xff008000);
  static const Color greenLight = Color(0xff34C759);
  static const Color orange = Color(0xffFFA500);
  static const Color yellow = Color(0xffFFCC00);

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientStart, gradientEnd],
  );
}
