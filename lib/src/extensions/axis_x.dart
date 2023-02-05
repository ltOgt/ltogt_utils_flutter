import 'package:flutter/widgets.dart';

extension AxisDirectionX on AxisDirection {
  bool get isHorizontal => this == AxisDirection.right || this == AxisDirection.left;
  bool get isVertical => !isHorizontal;
  bool get isReverse => (this == AxisDirection.left || this == AxisDirection.up);
  bool get isForward => !isReverse;
  Axis get axis => isHorizontal ? Axis.horizontal : Axis.vertical;
}

extension AxisX on Axis {
  bool get isHorizontal => this == Axis.horizontal;
  bool get isVertical => this == Axis.vertical;
}
