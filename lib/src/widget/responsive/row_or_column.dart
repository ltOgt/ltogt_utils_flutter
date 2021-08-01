import 'package:flutter/widgets.dart';

/// Easily switch between [Row] and [Column] depending on [axis].
class RowOrColumn extends StatelessWidget {
  const RowOrColumn({
    required this.axis,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textBaseline,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.leading,
    this.trailing,
  });

  final Axis axis;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      if (leading != null) leading!,
      ...children,
      if (trailing != null) trailing!,
    ];

    return axis == Axis.vertical
        ? Column(
            children: _children,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            textBaseline: textBaseline,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
          )
        : Row(
            children: _children,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            textBaseline: textBaseline,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
          );
  }
}
