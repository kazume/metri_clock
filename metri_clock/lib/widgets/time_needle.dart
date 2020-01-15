import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:metri_clock/bloc/clock_bloc.dart';
import 'package:metri_clock/config.dart';
import 'package:metri_clock/custom/clock_layout_delegate.dart';
import 'package:metri_clock/themes/themes.dart';
import 'package:provider/provider.dart';

/// CustomMultiChildLayout Widget containing most of the widgets of the clock
/// face. The ClockLayoutDelegate defines how the layout and positioning of these
/// widgets is done.
class TimeNeedle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark || useDarkThemeOnly
            ? darkTheme
            : lightTheme;
    final clockModel = Provider.of<ClockModel>(context);
    final clockBloc = Provider.of<ClockBloc>(context);
    final weather =
        '${clockModel.weatherString}, ${clockModel.temperature.toInt()}°';//${clockModel.unitString*}';
    final lowHigh = '{${clockModel.low.toInt()}-${clockModel.high.toInt()}}';
    return CustomMultiChildLayout(
      delegate: ClockLayoutDelegate(clockModel),
      children: [
        // main time indication
        LayoutId(
          child: StreamBuilder<DateTime>(
            stream: clockBloc.dateTime,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (clockModel.is24HourFormat) {
                  return buildTime24(
                      snapshot.data, colors[ThemeElement.primary]);
                } else {
                  return buildTime12(
                      snapshot.data, colors[ThemeElement.primary]);
                }
              } else {
                return Container();
              }
            },
          ),
          id: Id.TIME,
        ),
        // AM-PM if required, otherwise Container()
        LayoutId(
          child: Padding(
            padding: EdgeInsets.only(top: amPmTopPadding),
            child: StreamBuilder<DateTime>(
              stream: clockBloc.dateTime,
              builder: (context, snapshot) {
                if (!clockModel.is24HourFormat && snapshot.hasData) {
                  return buildAmPm(
                      snapshot.data, colors[ThemeElement.secondary]);
                }
                return Container();
              },
            ),
          ),
          id: Id.AM_PM,
        ),
        // (large part of the) needle
        LayoutId(
          child: Container(
            height: 3.0,
            color: colors[ThemeElement.primary],
          ),
          id: Id.NEEDLE,
        ),
        // time-weather separator line
        LayoutId(
          child: Container(
            color: colors[ThemeElement.secondary],
            height: 1.0,
          ),
          id: Id.TIME_WEATHER_SEPARATOR,
        ),
        // weather + temperature
        LayoutId(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              weather,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: largeFontWeight,
                fontStyle: FontStyle.italic,
                fontSize: smallFontSize,
                letterSpacing: -0.5,
                color: colors[ThemeElement.primary],
              ),
            ),
          ),
          id: Id.WEATHER,
        ),
        // hi-low temperatures
        LayoutId(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              lowHigh,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: smallFontWeight,
                fontSize: smallFontSize,
                letterSpacing: -0.5,
                color: colors[ThemeElement.secondary],
              ),
            ),
          ),
          id: Id.HI_LOW,
        ),
        // weather-date separator line
        LayoutId(
          child: Container(
            color: colors[ThemeElement.secondary],
            height: 1.0,
          ),
          id: Id.WEATHER_DATE_SEPARATOR,
        ),
        // date
        LayoutId(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: StreamBuilder<DateTime>(
              stream: Provider.of<ClockBloc>(context).dateTime,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final weekday = DateFormat('EEEE').format(snapshot.data);
                  final month = DateFormat('MMMM').format(snapshot.data);
                  final dayOfMonth = DateFormat('d').format(snapshot.data);
                  return Text(
                    '$weekday, $month $dayOfMonth',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: miniFontWeight,
                      fontSize: miniFontSize,
                      letterSpacing: -0.5,
                      color: colors[ThemeElement.secondary],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          id: Id.DATE,
        ),
      ],
    );
  }
}

// Widget builder functions

Widget buildAmPm(DateTime dateTime, Color color) {
  final amPm = DateFormat('aa').format(dateTime);
  return Text(
    amPm,
    style: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: largeFontWeight,
      fontSize: miniFontSize,
      letterSpacing: -0.7,
      color: color,
    ),
  );
}

Widget buildTime12(DateTime dateTime, Color color) {
  final hour = DateFormat('h').format(dateTime);
  final minute = DateFormat('mm').format(dateTime);
  return Text(
    '$hour:$minute',
    style: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: largeFontWeight,
      fontSize: largeFontSize,
      letterSpacing: -2.0,
      color: color,
    ),
  );
}

Widget buildTime24(DateTime dateTime, Color color) {
  final hour = DateFormat('HH').format(dateTime);
  final minute = DateFormat('mm').format(dateTime);
  return Text(
    '$hour:$minute',
    style: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: largeFontWeight,
      fontSize: largeFontSize,
      letterSpacing: -2.0,
      color: color,
    ),
  );
}
