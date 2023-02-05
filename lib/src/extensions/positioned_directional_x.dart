import 'package:flutter/widgets.dart';

extension PositionedDirectionalX on Positioned {
  /// Position a [child] with [start], [end], [left], [right]
  /// in respect to the [axisDirection].
  static Positioned directional({
    required Widget child,
    required AxisDirection axisDirection,
    double? start,
    double? end,
    double? left,
    double? right,
    double? mainAxisLength,
    double? crossAxisLength,
  }) {
    switch (axisDirection) {
      case AxisDirection.up:
        return Positioned(
          top: end,
          left: left,
          right: right,
          bottom: start,
          child: child,
          width: crossAxisLength,
          height: mainAxisLength,
        );
      case AxisDirection.down:
        return Positioned(
          top: start,
          left: right,
          right: left,
          bottom: end,
          child: child,
          width: crossAxisLength,
          height: mainAxisLength,
        );
      case AxisDirection.right:
        return Positioned(
          top: left,
          left: start,
          right: end,
          bottom: right,
          child: child,
          width: mainAxisLength,
          height: crossAxisLength,
        );
      case AxisDirection.left:
        return Positioned(
          top: right,
          left: end,
          right: start,
          bottom: left,
          child: child,
          width: mainAxisLength,
          height: crossAxisLength,
        );
    }
  }
}
