import 'package:flutter/material.dart';
import 'package:metri_clock/config.dart';
import 'package:metri_clock/themes/themes.dart';

/// A Dash on the TimeScale.
class Dash extends StatelessWidget {
  final double pixelsPerMinute;
  final ThemeElement themeElement;
  final double dashWidth;

  Dash.short({
    @required this.pixelsPerMinute,
    this.themeElement = ThemeElement.timeScaleSecondary,
  }) : dashWidth = DashWidth.SHORT.toDouble();

  Dash.medium({
    @required this.pixelsPerMinute,
    this.themeElement = ThemeElement.timeScaleSecondary,
  }) : dashWidth = DashWidth.MEDIUM.toDouble();

  Dash.long({
    @required this.pixelsPerMinute,
    this.themeElement = ThemeElement.timeScaleSecondary,
  }) : dashWidth = DashWidth.LONG.toDouble();

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark || useDarkThemeOnly
            ? darkTheme
            : lightTheme;
    return Container(
      height: pixelsPerMinute * 5,
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: dashWidth,
          height: 2,
          color: colors[themeElement],
        ),
      ),
    );
  }
}

enum DashWidth { SHORT, MEDIUM, LONG }

extension DashWidthAsDouble on DashWidth {
  double toDouble() {
    switch (this) {
      case DashWidth.SHORT:
        return shortDashWidth;
      case DashWidth.MEDIUM:
        return mediumDashWidth;
      case DashWidth.LONG:
        return longDashWidth;
      default:
        throw Exception('no default case implemented');
    }
  }
}
