import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class TextSpanGestureDetector extends StatefulWidget {
  const TextSpanGestureDetector({
    Key? key,
    required this.textSpan,
    this.onTapUp,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
  }) : super(key: key);

  /// The text that should be interactable
  final TextSpan textSpan;

  final void Function(TextPosition position, Offset localOffset)? onTapUp;

  final void Function(TextPosition position, Offset localOffset)? onPanStart;
  final void Function(TextPosition position, Offset localOffset)? onPanUpdate;
  final void Function()? onPanEnd;
  final void Function()? onPanCancel;

  @override
  _TextSpanGestureDetectorState createState() => _TextSpanGestureDetectorState();
}

// ===========================================================================
// ===========================================================================
// ===========================================================================
// ===========================================================================

class _TextSpanGestureDetectorState extends State<TextSpanGestureDetector> {
  // ===========================================================================
  // Text <-> Rect Conversions

  /// The key provided to the [RichText] rendering [widget.textSpan].
  /// Used to find the [_renderParagraph].
  final GlobalKey _richTextKey = GlobalKey();

  /// The [RenderParagraph] used to [_getRectsForSelection]
  RenderParagraph? get _renderParagraph => orNull(
        () => _richTextKey.currentContext!.findRenderObject() as RenderParagraph,
      );

  /// Converts a pointers [localOffset] to the corresponding [TextPosition]
  TextPosition _getPositionForOffset(Offset localOffset) {
    final myBox = context.findRenderObject();
    final textOffset = _renderParagraph!.globalToLocal(localOffset, ancestor: myBox);
    return _renderParagraph!.getPositionForOffset(textOffset);
  }

  // =================================================

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: widget.onTapUp == null
          ? null
          : (e) => widget.onTapUp!(
                _getPositionForOffset(e.localPosition),
                e.localPosition,
              ),
      child: GestureDetector(
        supportedDevices: {
          PointerDeviceKind.invertedStylus,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.touch,
          //PointerDeviceKind.trackpad  <-- Explicitly not this; trackpad scroll
        },
        onPanStart: widget.onPanStart == null
            ? null
            : (e) => widget.onPanStart!(
                  _getPositionForOffset(e.localPosition),
                  e.localPosition,
                ),
        onPanUpdate: widget.onPanUpdate == null
            ? null
            : (e) => widget.onPanUpdate!(
                  _getPositionForOffset(e.localPosition),
                  e.localPosition,
                ),
        onPanEnd: widget.onPanEnd == null ? null : (e) => widget.onPanEnd!(),
        onPanCancel: widget.onPanCancel == null ? null : () => widget.onPanCancel!(),
        behavior: HitTestBehavior.translucent,
        child: RichText(
          key: _richTextKey,
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [widget.textSpan],
          ),
        ),
      ),
    );
  }
}
