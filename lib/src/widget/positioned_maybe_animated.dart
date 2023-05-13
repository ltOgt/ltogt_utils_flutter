import 'package:flutter/widgets.dart';

class PositionedMaybeAnimated extends StatelessWidget {
  const PositionedMaybeAnimated({
    super.key,
    this.keyX,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
    this.durationForAnimation,
    this.curveForAnimation,
    this.onEndForAnimation,
  });

  PositionedMaybeAnimated.fromRect({
    super.key,
    this.keyX,
    required this.child,
    required Rect rect,
    this.curveForAnimation,
    this.durationForAnimation,
    this.onEndForAnimation,
  })  : left = rect.left,
        top = rect.top,
        width = rect.width,
        height = rect.height,
        right = null,
        bottom = null;

  final Key? keyX;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final Widget child;

  final Duration? durationForAnimation;
  final Curve? curveForAnimation;
  final VoidCallback? onEndForAnimation;

  @override
  Widget build(BuildContext context) {
    if (super.key != null) {
      print(super.key);
    }
    return durationForAnimation == null
        ? Positioned(
            key: keyX,
            left: left,
            top: top,
            right: right,
            bottom: bottom,
            width: width,
            height: height,
            child: child,
          )
        : AnimatedPositioned(
            key: keyX,
            duration: durationForAnimation!,
            curve: curveForAnimation ?? Curves.linear,
            onEnd: onEndForAnimation,
            left: left,
            top: top,
            right: right,
            bottom: bottom,
            width: width,
            height: height,
            child: child,
          );
  }
}
