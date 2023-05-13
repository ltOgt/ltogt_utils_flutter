import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/src/widget/positioned_maybe_animated.dart';

extension PositionedOnEdgeX on Positioned {
  static PositionedMaybeAnimated top({required Widget child, Duration? duration, Key? key}) => PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0,
        left: 0,
        right: 0,
        child: child,
      );
  static PositionedMaybeAnimated left({required Widget child, Duration? duration, Key? key}) => PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0,
        left: 0,
        bottom: 0,
        child: child,
      );
  static PositionedMaybeAnimated bottom({required Widget child, Duration? duration, Key? key}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        bottom: 0,
        left: 0,
        right: 0,
        child: child,
      );
  static PositionedMaybeAnimated right({required Widget child, Duration? duration, Key? key}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0,
        right: 0,
        bottom: 0,
        child: child,
      );

  static PositionedMaybeAnimated topLeft({required Widget child, Duration? duration, Key? key}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0,
        left: 0,
        child: child,
      );
  static PositionedMaybeAnimated topRight({required Widget child, Duration? duration, Key? key}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0,
        right: 0,
        child: child,
      );
  static PositionedMaybeAnimated bottomLeft({required Widget child, Duration? duration, Key? key}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        bottom: 0,
        left: 0,
        child: child,
      );
  static PositionedMaybeAnimated bottomRight({required Widget child, Duration? duration, Key? key}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        bottom: 0,
        right: 0,
        child: child,
      );
}
