import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

// TODO use in [SplitPageToContent]

/// Renders a [seperator] between [childA] and [childB] that can be dragged
/// to update the [fractionA] via [onFractionChanged].
class SplitResizable extends StatefulWidget {
  const SplitResizable({
    super.key,
    required this.childA,
    required this.childB,
    required this.axis,
    required this.fractionA,
    required this.onFractionChanged,
    required this.seperator,
    required this.seperatorWidth,
  }) : assert(fractionA > 0 && fractionA < 1);

  final Widget childA;
  final Widget childB;
  final Axis axis;
  final double fractionA;
  final ValueChanged<double> onFractionChanged;

  /// The seperator that is shown between [childA] and [childB]
  /// Is unconstrained in the crossAxis and has [seperatorWidth] in the [axis]
  final Widget seperator;
  final double seperatorWidth;

  @override
  State<SplitResizable> createState() => _SplitResizableState();
}

class _SplitResizableState extends State<SplitResizable> {
  final GlobalKey _rootKey = GlobalKey();

  late double _fractionA = widget.fractionA;

  int get _flexA => (_fractionA * 100).round();
  int get _flexB => ((1 - _fractionA) * 100).round();

  bool get _isHorizontal => widget.axis == Axis.horizontal;

  @override
  void didUpdateWidget(covariant SplitResizable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fractionA != oldWidget.fractionA) {
      setState(() {
        _fractionA = widget.fractionA;
      });
    }
  }

  bool _isDragging = false;
  void onDragStart(dynamic) => setState(() {
        _isDragging = true;
      });
  void onDragEnd(dynamic) => setState(() {
        _isDragging = false;
      });
  void onDragUpdate(DragUpdateDetails details) {
    final r = RenderHelper.getRect(globalKey: _rootKey);
    if (r == null) return;

    final dimension = _isHorizontal ? r.width : r.height;
    final localPosition = details.globalPosition - r.topLeft;
    final position = _isHorizontal ? localPosition.dx : localPosition.dy;
    final newFraction = position / dimension;

    widget.onFractionChanged(max(0.1, min(0.9, newFraction)));
  }

  MouseCursor get _cursor => _isHorizontal ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _isDragging ? _cursor : MouseCursor.defer,
      child: RowOrColumn(
        key: _rootKey,
        axis: widget.axis,
        children: [
          Flexible(
            flex: _flexA,
            child: widget.childA,
          ),
          MouseRegion(
            cursor: _cursor,
            child: GestureDetector(
              // i.e. NOT trackpad
              supportedDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus},
              onHorizontalDragUpdate: _isHorizontal ? onDragUpdate : null,
              onHorizontalDragStart: _isHorizontal ? onDragStart : null,
              onHorizontalDragEnd: _isHorizontal ? onDragEnd : null,
              onVerticalDragUpdate: !_isHorizontal ? onDragUpdate : null,
              onVerticalDragStart: !_isHorizontal ? onDragStart : null,
              onVerticalDragEnd: !_isHorizontal ? onDragEnd : null,
              child: Container(
                height: !_isHorizontal ? widget.seperatorWidth : double.infinity,
                width: _isHorizontal ? widget.seperatorWidth : double.infinity,
                child: widget.seperator,
              ),
            ),
          ),
          Flexible(
            flex: _flexB,
            child: widget.childB,
          ),
        ],
      ),
    );
  }
}
