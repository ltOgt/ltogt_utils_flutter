import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/src/widget/positioned_maybe_animated.dart';

extension PositionedOnEdgeX on Positioned {
  static PositionedMaybeAnimated fromAlignment({
    required Alignment alignment,
    required Widget child,
    Duration? duration,
    Key? key,
    double delta = 0,
  }) {
    assert([-1.0, 0, 1].contains(alignment.x));
    assert([-1.0, 0, 1].contains(alignment.y));

    switch (alignment) {
      case Alignment.topLeft:
        return topLeft(child: child, deltaLeft: delta, deltaTop: delta, duration: duration);
      case Alignment.topCenter:
        return top(child: child, delta: delta, duration: duration);
      case Alignment.topRight:
        return topRight(child: child, deltaRight: delta, deltaTop: delta, duration: duration);
      case Alignment.centerLeft:
        return left(child: child, delta: delta, duration: duration);

      case Alignment.centerRight:
        return right(child: child, delta: delta, duration: duration);
      case Alignment.bottomLeft:
        return bottomLeft(child: child, deltaLeft: delta, deltaBottom: delta, duration: duration);
      case Alignment.bottomCenter:
        return bottom(child: child, delta: delta, duration: duration);
      case Alignment.bottomRight:
        return bottomRight(child: child, deltaRight: delta, deltaBottom: delta, duration: duration);
      case Alignment.center:
      case _:
        return PositionedMaybeAnimated(
          keyX: key,
          durationForAnimation: duration,
          child: child,
        );
    }
  }

  static PositionedMaybeAnimated top({required Widget child, Duration? duration, Key? key, double delta = 0}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0 + delta,
        left: 0,
        right: 0,
        child: child,
      );
  static PositionedMaybeAnimated left({required Widget child, Duration? duration, Key? key, double delta = 0}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0,
        left: 0 + delta,
        bottom: 0,
        child: child,
      );
  static PositionedMaybeAnimated bottom({required Widget child, Duration? duration, Key? key, double delta = 0}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        bottom: 0 + delta,
        left: 0,
        right: 0,
        child: child,
      );
  static PositionedMaybeAnimated right({required Widget child, Duration? duration, Key? key, double delta = 0}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0,
        right: 0 + delta,
        bottom: 0,
        child: child,
      );

  static PositionedMaybeAnimated topLeft(
          {required Widget child, Duration? duration, Key? key, double deltaTop = 0, double deltaLeft = 0}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0 + deltaTop,
        left: 0 + deltaLeft,
        child: child,
      );
  static PositionedMaybeAnimated topRight(
          {required Widget child, Duration? duration, Key? key, double deltaTop = 0, double deltaRight = 0}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        top: 0 + deltaTop,
        right: 0 + deltaRight,
        child: child,
      );
  static PositionedMaybeAnimated bottomLeft(
          {required Widget child, Duration? duration, Key? key, double deltaBottom = 0, double deltaLeft = 0}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        bottom: 0 + deltaBottom,
        left: 0 + deltaLeft,
        child: child,
      );
  static PositionedMaybeAnimated bottomRight(
          {required Widget child, Duration? duration, Key? key, double deltaBottom = 0, double deltaRight = 0}) =>
      PositionedMaybeAnimated(
        keyX: key,
        durationForAnimation: duration,
        bottom: 0 + deltaBottom,
        right: 0 + deltaRight,
        child: child,
      );
}
