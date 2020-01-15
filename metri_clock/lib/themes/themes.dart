import 'package:flutter/material.dart';

enum ThemeElement { background, primary, secondary, timeScalePrimary, timeScaleSecondary }

final lightTheme = {
  ThemeElement.background: Colors.white,
  ThemeElement.primary: Color(0xFF7c8d6f), //Color(0xFF5b7bb2),
  ThemeElement.secondary: Color(0xFF555d4f), //Color(0xFF48628E),
  ThemeElement.timeScalePrimary: Color(0xFFaeacac), //Colors.white,
  ThemeElement.timeScaleSecondary: Color(0xFFdbdbdb), //Color(0xFF545455),
};

final darkTheme = {
  ThemeElement.background: Color(0xff2d2d2e),
  ThemeElement.primary: Color(0xFF7c8d6f), //Color(0xFF5b7bb2),
  ThemeElement.secondary: Color(0xFF7c8d6f).withOpacity(0.6), //Color(0xFF48628E),
  ThemeElement.timeScalePrimary: Color(0xFFD9D9D9), //Colors.white,
  ThemeElement.timeScaleSecondary: Color(0xFF545455),
};