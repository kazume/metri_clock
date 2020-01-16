import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metri_clock/config.dart';
import 'package:metri_clock/themes/themes.dart';
import 'package:metri_clock/widgets/dash.dart';
import 'package:metri_clock/widgets/time_needle.dart';
import 'package:metri_clock/widgets/time_scale.dart';

/// The Clock itself.
class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  final containerKey = GlobalKey();
  TimeScale timeScale = TimeScale(key: UniqueKey());

  @override
  void didChangeDependencies() {
    // get the height of the ClockCustomizer and forward it to the TimeScale
    // so it calculates the position of the DateTime correctly
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => timeScale.updateHeight(containerKey.currentContext.size.height),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final colors =
        Theme.of(context).brightness == Brightness.dark || useDarkThemeOnly
            ? darkTheme
            : lightTheme;
    return Container(
      key: containerKey,
      color: colors[ThemeElement.background],
      child: Stack(
        children: [
          // the needle, time, weather and date widgets
          TimeNeedle(),
          // the scale on the left of the screen, including the hour as text
          timeScale,
          // the small part of the needle that needs to overlap the TimeScale
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: paddingLeft),
              child: Container(
                height: pixelsPerMinute,
                width: DashWidth.LONG.toDouble() + 2.0, // +2.0 px to create overlap
                color: colors[ThemeElement.primary],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
