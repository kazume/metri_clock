import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

// CONFIG parameters

// padding and spacing
final paddingLeft = 30.0;
final paddingRight = 50.0;
final spaceBtnTimeAndNeedle = 10.0;
final spaceBtnHiLowAndWeather = 5.0;
final spaceBtnTimeAndAmPm = 2.0;
final amPmTopPadding = 11.0;

// the different dash widths (opted for only 2 different sizes in the end)
final longDashWidth = 60.0; // hour and half-hour
final mediumDashWidth = 30.0; // 15-minute
final shortDashWidth = 30.0; // the rest

// the font size and weight of the main time text on the center right
final largeFontSize = 70.0;
final largeFontWeight = FontWeight.w600;

// the font size and weight of the hour indication on the TimeScale
final mediumFontSize = 37.0;
final mediumFontWeight = FontWeight.w500;

// the font size and weight of AM-PM and weather
final smallFontSize = 25.0;
final smallFontWeight = FontWeight.w400;

// the font size and weight of the date
final miniFontSize = 18.0;
final miniFontWeight = FontWeight.w400;

// TimeScale movement/animation parameters
final animationDuration = Duration(milliseconds: 500);
final animationLeadingDuration = Duration(milliseconds: 500);
final animationCurve = Curves.linear;

// cause we really actually only included the light design as a bonus
// the dark one is the one the clock is primarily designed for
final useDarkThemeOnly = true;