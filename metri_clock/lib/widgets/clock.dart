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

class _ClockState extends State<Clock> with ChangeNotifier {
  final containerKey = GlobalKey();
  double containerHeight = 0;
  TimeScale timeScale = TimeScale(key: UniqueKey());

  @override
  void initState() {
    addListener((){});
    WidgetsBinding.instance.addPostFrameCallback((context) {
      containerHeight = containerKey.currentContext.size.height;
      timeScale.updateHeight(containerHeight);
      notifyListeners();
    });
    super.initState();
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
