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
  ScrollController controller = ScrollController();
  StreamSubscription subscription;
  double containerHeight = 0;

  void updateHeight(double height) {
    containerHeight = height;
    _scrollToPositionFor(DateTime.now(), animated: false);
  }

  @override
  void didChangeDependencies() {
    subscription = Provider.of<ClockBloc>(context).animationDateTime.listen(
      (dateTime) {
        _scrollToPositionFor(dateTime);
      },
    );
    super.didChangeDependencies();
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
                  Dash.short(),
                  Dash.short(),
                  Dash.medium(),
                  Dash.short(),
                  Dash.short(),
                  Dash.long(
                    themeElement: ThemeElement.timeScalePrimary,
                  ),
                  Dash.short(),
                  Dash.short(),
                  Dash.medium(),
                  Dash.short(),
                  Dash.short(),
                  Dash.long(),
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

  void _scrollToPositionFor(DateTime dateTime, {bool animated = true}) {
    final newOffset = _calculatePosition(dateTime);
    // checking haveDimensions prevents a NoSuchMethodError: The method '>'
    // was called on null. when calling controller.animateTo()
    if (controller != null &&
        controller.hasClients &&
        controller.position.haveDimensions) {
      if (animated) {
        controller.animateTo(newOffset,
            duration: animationDuration, curve: animationCurve);
      } else {
        controller.jumpTo(newOffset);
      }
    }
  }

  double _calculatePosition(DateTime dateTime) {
    // the scale starts 25' before 0
    final scaleStart = pixelsPerMinute * 25;
    // skip a day to allow for enough buffer before 0
    final oneDay = pixelsPerMinute * 60 * 24;
    final minutes = dateTime.hour * 60 + dateTime.minute;

    return scaleStart +
        minutes * pixelsPerMinute +
        oneDay -
        (containerHeight / 2) +
        (pixelsPerMinute / 2);
  }
}
