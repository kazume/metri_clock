import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:metri_clock/config.dart';
import 'package:metri_clock/widgets/dash.dart';

/// MultiChildLayoutDelegate in charge of the layout and positioning of most of
/// the Clock's Widgets
class ClockLayoutDelegate extends MultiChildLayoutDelegate {
  final ClockModel clockModel;
  Size timeSize = Size.zero;
  Size needleLargeSize = Size.zero;
  Size timeWeatherSeparatorSize = Size.zero;
  Size hiLowSize = Size.zero;
  Size weatherDateSeparatorSize = Size.zero;
  Size amPmSize = Size.zero;
  Offset reusableOffset = Offset.zero;
  double finalPaddingRight = paddingRight;

  ClockLayoutDelegate(this.clockModel);

  @override
  void performLayout(Size size) {
    // layout amPm, then adjust the right padding if it will be shown
    // note: when 24-hour-format is in use, the Widget is a Container
    amPmSize = layoutChild(Id.AM_PM, BoxConstraints());
    if (!clockModel.is24HourFormat) {
      finalPaddingRight = paddingRight + amPmSize.width;
    }
    // layout and position time
    timeSize = layoutChild(Id.TIME, BoxConstraints.loose(size));
    reusableOffset = size.centerRight(Offset.zero) +
        Offset(
          -(timeSize.width + finalPaddingRight),
          -timeSize.height / 2,
        );
    positionChild(Id.TIME, reusableOffset);

    // position AM-PM indicator on the right top of time
    final amPmOffset = reusableOffset +
        Offset(
          timeSize.width + spaceBtnTimeAndAmPm,
          0.0,
        );
    positionChild(Id.AM_PM, amPmOffset);

    // define the Size of large needle, layout and position it
    needleLargeSize = Size(
        size.width -
            paddingLeft -
            DashWidth.LONG.toDouble() -
            finalPaddingRight -
            timeSize.width -
            spaceBtnTimeAndNeedle,
        3.0);
    layoutChild(Id.NEEDLE, BoxConstraints.tight(needleLargeSize));
    final needleOffset = size.centerLeft(Offset.zero) +
        Offset(
          paddingLeft + DashWidth.LONG.toDouble(),
          -needleLargeSize.height / 2,
        );
    positionChild(Id.NEEDLE, needleOffset);

    // layout and position separator between time and weather
    timeWeatherSeparatorSize = layoutChild(
      Id.TIME_WEATHER_SEPARATOR,
      BoxConstraints.tight(
        Size(timeSize.width + spaceBtnTimeAndNeedle, 1.0),
      ),
    );
    reusableOffset = reusableOffset +
        Offset(
          -spaceBtnTimeAndNeedle,
          timeSize.height,
        );
    positionChild(Id.TIME_WEATHER_SEPARATOR, reusableOffset);

    // layout and position hi-low
    hiLowSize = layoutChild(Id.HI_LOW, BoxConstraints());
    final hiLowOffset = size.topRight(Offset.zero) +
        Offset(
          -(hiLowSize.width + finalPaddingRight),
          reusableOffset.dy + timeWeatherSeparatorSize.height,
        );
    positionChild(Id.HI_LOW, hiLowOffset);

    // layout and position weather
    final weatherSize = layoutChild(Id.WEATHER, BoxConstraints());
    final weatherOffset = size.topRight(Offset.zero) +
        Offset(
          -(weatherSize.width +
              finalPaddingRight +
              hiLowSize.width +
              spaceBtnHiLowAndWeather),
          reusableOffset.dy + timeWeatherSeparatorSize.height,
        );
    positionChild(Id.WEATHER, weatherOffset);

    // layout and position separator between weather and date
    weatherDateSeparatorSize = layoutChild(
      Id.WEATHER_DATE_SEPARATOR,
      BoxConstraints.tight(
        Size(timeSize.width + spaceBtnTimeAndNeedle, 1.0),
      ),
    );
    reusableOffset = reusableOffset +
        Offset(
          0.0,
          timeWeatherSeparatorSize.height + hiLowSize.height,
        );
    positionChild(Id.WEATHER_DATE_SEPARATOR, reusableOffset);

    // layout and position date
    final dateSize = layoutChild(Id.DATE, BoxConstraints());
    final offset = size.topRight(Offset.zero) +
        Offset(
          -(dateSize.width + finalPaddingRight),
          reusableOffset.dy,
        );
    positionChild(Id.DATE, offset);
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}

/// The Id's for the widgets the ClockLayoutDelegate needs to handle
enum Id {
  TIME,
  AM_PM,
  NEEDLE,
  DATE,
  WEATHER,
  HI_LOW,
  TIME_WEATHER_SEPARATOR,
  WEATHER_DATE_SEPARATOR
}
