import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class TextSpanDetails {
  /// The current [TextPosition] at time of the event.
  final TextPosition textPosition;

  /// The current local [Offset] at time of the event.
  final Offset offsetLocal;

  const TextSpanDetails({
    required this.textPosition,
    required this.offsetLocal,
  });

  TextSelection get selection => TextSelection.fromPosition(textPosition);
  Rect get rectLocal => offsetLocal & Size.zero;
}

class TextSpanPanDetails extends TextSpanDetails {
  const TextSpanPanDetails({
    required super.textPosition,
    required super.offsetLocal,
    required this.textPositionStart,
    required this.offsetLocalStart,
  });

  /// The initial [TextPosition] that started the pan
  final TextPosition textPositionStart;

  /// The initial [Offset] that started the pan
  final Offset offsetLocalStart;

  @override
  TextSelection get selection => TextSelection(
        baseOffset: textPositionStart.offset,
        extentOffset: textPosition.offset,
      );

  @override
  Rect get rectLocal => Rect.fromPoints(offsetLocalStart, offsetLocal);
}

class TextSpanGestureDetector extends StatefulWidget {
  const TextSpanGestureDetector({
    Key? key,
    required this.textSpan,
    this.onTapUp,
    this.onDoubleTapDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
  }) : super(key: key);

  /// The text that should be interactable
  final TextSpan textSpan;

  final void Function(TextSpanDetails)? onTapUp;
  final void Function(TextSpanDetails)? onDoubleTapDown;
  final void Function(TextSpanDetails)? onPanStart;
  final void Function(TextSpanPanDetails)? onPanUpdate;
  final void Function(TextSpanPanDetails)? onPanEnd;
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
  // Always set before usage, no need to reset either
  late Offset panStartOffset, panEndOffset;
  late TextPosition panStartPosition, panEndPosition;

  bool get hasUpdateOrEnd => widget.onPanUpdate != null || widget.onPanEnd != null;

  void onPanStart(DragStartDetails d) {
    final offset = d.localPosition;
    final position = _getPositionForOffset(offset);

    if (hasUpdateOrEnd) {
      panStartOffset = offset;
      panStartPosition = position;
      panEndOffset = offset;
      panEndPosition = position;
    }

    widget.onPanStart?.call(TextSpanDetails(textPosition: position, offsetLocal: offset));
  }

  void onPanUpdate(DragUpdateDetails d) {
    final offset = d.localPosition;
    final position = _getPositionForOffset(offset);

    panEndOffset = offset;
    panEndPosition = position;

    widget.onPanUpdate?.call(TextSpanPanDetails(
      textPosition: panEndPosition,
      offsetLocal: panEndOffset,
      textPositionStart: panStartPosition,
      offsetLocalStart: panStartOffset,
    ));
  }

  void onPanEnd(DragEndDetails d) {
    widget.onPanEnd?.call(TextSpanPanDetails(
      textPosition: panEndPosition,
      offsetLocal: panEndOffset,
      textPositionStart: panStartPosition,
      offsetLocalStart: panStartOffset,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      supportedDevices: {
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.touch,
        //PointerDeviceKind.trackpad  <-- Explicitly not this; trackpad scroll
      },
      onTapUp: widget.onTapUp == null
          ? null
          : (e) => widget.onTapUp!(TextSpanDetails(
                textPosition: _getPositionForOffset(e.localPosition),
                offsetLocal: e.localPosition,
              )),
      onDoubleTapDown: widget.onDoubleTapDown == null
          ? null
          : (e) => widget.onDoubleTapDown!(TextSpanDetails(
                textPosition: _getPositionForOffset(e.localPosition),
                offsetLocal: e.localPosition,
              )),
      onPanStart: hasUpdateOrEnd || widget.onPanStart != null ? onPanStart : null,
      onPanUpdate: hasUpdateOrEnd ? onPanUpdate : null,
      onPanEnd: widget.onPanEnd != null ? onPanEnd : null,
      onPanCancel: widget.onPanCancel == null ? null : () => widget.onPanCancel!(),
      behavior: HitTestBehavior.translucent,
      child: RichText(
        key: _richTextKey,
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [widget.textSpan],
        ),
      ),
    );
  }
}
