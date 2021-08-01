import 'package:flutter/widgets.dart';

/// Easily switch between [Row] and [Column] depending on [axis].
class RowOrColumn extends StatelessWidget {
  const RowOrColumn({
    required this.axis,
    this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textBaseline,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.leading,
    this.trailing,
    this.child,
  })  : assert(
          children != null || child != null,
          "Main Content required",
        ),
        assert(
          child == null || children == null,
          "Use child only as replacement for children",
        );

  final Axis axis;
  final List<Widget>? children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;

  /// Put before [children] (or [child])
  final Widget? leading;

  /// Put after [children] (or [child])
  final Widget? trailing;

  /// Replacement for [children].
  /// Mainly useful if [leading] and [trailing] are non null, and only on "child" exists.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      if (leading != null) leading!,
      if (children != null) ...children! else child!,
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
