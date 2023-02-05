import 'package:flutter/widgets.dart';

extension PositionedOnEdgeX on Positioned {
  static Positioned top(Widget child) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: child,
      );
  static Positioned left(Widget child) => Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        child: child,
      );
  static Positioned bottom(Widget child) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: child,
      );
  static Positioned right(Widget child) => Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        child: child,
      );
}
