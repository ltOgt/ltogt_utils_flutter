import 'package:flutter/widgets.dart';

extension AxisDirectionX on AxisDirection {
  bool get isHorizontal => this == AxisDirection.right || this == AxisDirection.left;
  bool get isVertical => !isHorizontal;
  bool get isReverse => (this == AxisDirection.left || this == AxisDirection.up);
  bool get isForward => !isReverse;
  Axis get axis => isHorizontal ? Axis.horizontal : Axis.vertical;

  bool get isRight => this == AxisDirection.right;
  bool get isLeft => this == AxisDirection.left;
  bool get isUp => this == AxisDirection.up;
  bool get isDown => this == AxisDirection.down;
}

extension AxisX on Axis {
  bool get isHorizontal => this == Axis.horizontal;
  bool get isVertical => this == Axis.vertical;
}
