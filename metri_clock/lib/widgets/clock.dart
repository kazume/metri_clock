import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metri_clock/config.dart';
import 'package:metri_clock/themes/themes.dart';
import 'package:metri_clock/widgets/dash.dart';
import 'package:metri_clock/widgets/time_needle.dart';
import 'package:metri_clock/widgets/time_scale.dart';

/// The Clock itself.
class Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final colors =
    Theme.of(context).brightness == Brightness.dark || useDarkThemeOnly
        ? darkTheme
        : lightTheme;
    return Container(
      color: colors[ThemeElement.background],
      child: Stack(
        children: [
          // the needle, time, weather and date widgets
          TimeNeedle(),
          // the scale on the left of the screen, including the hour as text
          TimeScale(key: UniqueKey()),
          // the small part of the needle that needs to overlap the TimeScale
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: paddingLeft),
              child: Container(
                height: 3,
                width: DashWidth.LONG.toDouble(),
                color: colors[ThemeElement.primary],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

