import 'package:flutter/widgets.dart';

class SizedBoxAxis extends StatelessWidget {
  const SizedBoxAxis({
    super.key,
    required this.axis,
    this.mainAxisSize,
    this.crossAxisSize,
    this.child,
  });

  final Axis axis;
  final double? mainAxisSize;
  final double? crossAxisSize;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = axis == Axis.horizontal;
    return SizedBox(
      width: isHorizontal ? mainAxisSize : crossAxisSize,
      height: isHorizontal ? crossAxisSize : mainAxisSize,
      child: child,
    );
  }
}
