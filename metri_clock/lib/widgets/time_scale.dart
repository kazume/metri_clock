import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:metri_clock/bloc/clock_bloc.dart';
import 'package:metri_clock/config.dart';
import 'package:metri_clock/themes/themes.dart';
import 'package:metri_clock/widgets/dash.dart';
import 'package:provider/provider.dart';

/// The time as scale.
class TimeScale extends StatefulWidget {
  TimeScale({key: Key}) : super(key: key);
  final _timeScaleState = _TimeScaleState();

  @override
  _TimeScaleState createState() => _timeScaleState;

  void updateHeight(double height) {
    _timeScaleState.updateHeight(height);
  }
}

class _TimeScaleState extends State<TimeScale> {
  ScrollController controller;
  StreamSubscription subscription;
  double containerHeight;

  void updateHeight(double height) {
    containerHeight = height;
    _setInitialScrollPosition(height);
  }

  @override
  void didChangeDependencies() {
    //final screenHeight = MediaQuery.of(context).size.height;
    controller = ScrollController(
      initialScrollOffset: calculatePosition(
        DateTime.now(),
        containerHeight,
      ),
    );
    subscription = Provider.of<ClockBloc>(context).animationDateTime.listen(
      (dateTime) {
        final newOffset = calculatePosition(dateTime, containerHeight);
        if (controller != null &&
            controller.hasClients &&
            controller.position.haveDimensions) {
          // checking haveDimensions prevents a NoSuchMethodError: The method '>'
          // was called on null. when calling controller.animateTo()
          controller.animateTo(newOffset,
              duration: animationDuration, curve: animationCurve);
        }
      },
    );
    super.didChangeDependencies();
  }

  void _setInitialScrollPosition(double position) {
    final newOffset = calculatePosition(DateTime.now(), containerHeight);
    if (controller != null &&
        controller.hasClients &&
        controller.position.haveDimensions) {
      // checking haveDimensions prevents a NoSuchMethodError: The method '>'
      // was called on null. when calling controller.animateTo()
      controller.jumpTo(newOffset);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark || useDarkThemeOnly
            ? darkTheme
            : lightTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final pixelsPerMinute = (screenHeight / 24 / 5).round().toDouble();
    print('screenheight = $screenHeight');
    print('pixelsPerMinute = $pixelsPerMinute');
    return Padding(
      padding: EdgeInsets.only(left: paddingLeft),
      child: ListView.builder(
        //physics: NeverScrollableScrollPhysics(),
        controller: controller,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dash.short(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.short(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.medium(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.short(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.short(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.long(
                    pixelsPerMinute: pixelsPerMinute,
                    themeElement: ThemeElement.timeScalePrimary,
                  ),
                  Dash.short(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.short(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.medium(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.short(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.short(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                  Dash.long(
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 0.0, //8.0
                  bottom: 30.0, // 23.0
                ),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            colors[ThemeElement.background].withOpacity(0.35),
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.elliptical(60, 20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      Provider.of<ClockModel>(context).is24HourFormat
                          ? index.remainder(24).toString()
                          : index.remainder(12).toString(),
                      style: TextStyle(
                        fontSize: mediumFontSize,
                        fontWeight: mediumFontWeight,
                        letterSpacing: -0.5,
                        color: colors[ThemeElement.timeScalePrimary],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

double calculatePosition(
  DateTime dateTime,
  double screenHeight,
) {
  if (screenHeight == null) return 0.0;
  final pixelsPerMinute = (screenHeight / 24 / 5).round().toDouble();
  // the scale begins 25' before 0
  final scaleStart = pixelsPerMinute * 25;
  // skip a day to allow for enough buffer before 0
  final oneDay = pixelsPerMinute * 60 * 24;
  final minutes = dateTime.hour * 60 + dateTime.minute;
  return scaleStart +
      minutes * pixelsPerMinute +
      oneDay -
      (screenHeight / 2) + pixelsPerMinute/2/* +
      pixelsPerMinute*/;
}
