import 'dart:async';

import 'package:metri_clock/config.dart';
import 'package:rxdart/rxdart.dart';

/// Exposes the DateTime for both TimeNeedle and TimeScale indications via 2
/// streams. The animationDateTime (used for the TimeScale) is added slightly
/// earlier (animationLeadingDuration in config.dart) to allow for an animation
/// starting ahead of the actual time change.
class ClockBloc {
  // the DateTime shown on the clock
  final _dateTime = BehaviorSubject<DateTime>();

  // the DateTime used to trigger the animation of the TimeScale, its Duration
  // is defined by animationLeadingDuration in config.dart
  final _animationDateTime = BehaviorSubject<DateTime>();

  // the trigger threshold needed to determine the exact moment to start the
  // TimeScale animation
  final _triggerThresholdInMillis =
      (animationLeadingDuration.inMilliseconds / 1000).ceil() * 1000;
  Timer _timer;

  ClockBloc() {
    _updateTime();
  }

  /// Returns a stream with the current DateTime.
  ValueStream<DateTime> get dateTime => _dateTime.stream;

  /// Returns a stream with the DateTime to be used with the TimeScale - this
  /// stream posts the next DateTime animationLeadingDuration (from config.dart)
  /// before the actual time (minute) change.
  ValueStream<DateTime> get animationDateTime => _animationDateTime.stream;

  void dispose() {
    _dateTime.close();
    _animationDateTime.close();
    _timer?.cancel();
  }

  void _updateTime() {
    final dateTime = DateTime.now();
    _dateTime.add(dateTime);
    final millisToGo =
        60000 - (_dateTime.value.millisecond + _dateTime.value.second * 1000);
    final millisToGoRoundedUp = (millisToGo / 1000).ceil() * 1000;
    // determine the closest 1000 millis that contains the leadingAnimationDuration
    if (millisToGoRoundedUp == _triggerThresholdInMillis) {
      final delay = Duration(
          milliseconds: millisToGo - animationLeadingDuration.inMilliseconds);
      final now = DateTime.now();
      // add millis to get the next minute (we use the rounded up one to be on
      // the safe side - we're not showing seconds anyway)
      final nextDateTime = now.add(Duration(milliseconds: millisToGoRoundedUp));
      Future.delayed(
        delay,
        () => _animationDateTime.add(nextDateTime),
      );
    } else if (millisToGoRoundedUp > _triggerThresholdInMillis &&
        _dateTime.value != null &&
        _animationDateTime.value != null &&
        _dateTime.value.minute != _animationDateTime.value.minute) {
      // if the time the clock starts up is close to the next minute
      // (< leadingAnimationDuration) the TimeScale isn't updated as the trigger
      // for the animationDateTime change has already passed. To prevent this
      // from happening we check to make sure the animationDateTime and
      // dateTime minutes correspond when not in the animation window.
      _animationDateTime.add(_dateTime.value);
    }

    _timer = Timer(
      Duration(seconds: 1) -
          Duration(milliseconds: dateTime.millisecond) -
          Duration(microseconds: dateTime.microsecond),
      _updateTime,
    );
  }
}
