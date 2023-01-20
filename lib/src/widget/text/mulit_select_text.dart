import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'package:ltogt_utils_flutter/src/widget/constraints_changed_notifier.dart';

/// Text Selection defined by [TextRange],
/// with optional [build] to style the selection boxes.
///
/// Used by [MultiSelectText].
class MultiSelectTextSelection {
  final TextRange textRange;
  final Widget Function(List<Rect> rects)? build;

  MultiSelectTextSelection({
    required this.textRange,
    this.build,
  });

  @override
  bool operator ==(covariant MultiSelectTextSelection other) {
    if (identical(this, other)) return true;

    return other.textRange == textRange && other.build == build;
  }

  @override
  int get hashCode => textRange.hashCode ^ build.hashCode;
}

// =============================================================================
// =============================================================================
// =============================================================================
// =============================================================================

/// {@template selectableText}
/// A [textSpan] that can have multiple existing [selections].
///
/// Reports selection clicks via [onTapUpSelection].
///
/// Reports the intention to create a new selection via
/// [onNewSelectionUpdate] and [onNewSelectionDone],
/// which can be used by the parent to update [selections].
/// {@endtemplate}
class MultiSelectText extends StatefulWidget {
  /// {@macro selectableText}
  const MultiSelectText({
    Key? key,
    required this.textSpan,
    required this.selections,
    this.onNewSelectionUpdate,
    this.onNewSelectionDone,
    this.onTapUpSelection,
    this.defaultSelectionColor = kSelectionColorDefault,
  }) : super(key: key);

  /// The text that should be made selectable
  final TextSpan textSpan;

  /// the existing selections
  final List<MultiSelectTextSelection> selections;

  /// Called while the user creates a new selection
  final void Function(TextSelection)? onNewSelectionUpdate;

  /// Called when the user finishes the new selection.
  /// Check [TextSelection.isCollapsed] to see whether the selection is empty.
  final void Function(TextSelection)? onNewSelectionDone;

  /// Called when the user taps on one of the [selections]
  final void Function(TextPosition selection, Rect localRect)? onTapUpSelection;

  /// The color to use for active selections.
  /// And for undefined [MultiSelectTextSelection.build].
  final Color defaultSelectionColor;

  /// Half transparent [Colors.blue]
  static const kSelectionColorDefault = const Color(0x882196F3);

  @override
  _MultiSelectTextState createState() => _MultiSelectTextState();
}

// ===========================================================================
// ===========================================================================
// ===========================================================================
// ===========================================================================

class _MultiSelectTextState extends State<MultiSelectText> {
  /// We cache the text lenght since it is not free to get.
  /// ( Need to call [TextSpan.toPlainText])
  late int textLength;
  _storeTextLenght() {
    textLength = widget.textSpan.toPlainText().length;
  }

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

  /// Converts a [TextSelection] to the corresponding [Rect]s.
  List<Rect> _getRectsForSelection(TextSelection selection) =>
      _renderParagraph?.getBoxesForSelection(selection).map((e) => e.toRect()).toList() ?? [];

  /// Converts a pointers [localOffset] to the corresponding [Rect].
  Rect? _getRectUnderOffset(Offset localOffset) {
    for (final rects in _rectBySelection.values) {
      for (final rect in rects) {
        if (rect.contains(localOffset)) {
          print(rect);
          return rect;
        }
      }
    }
    return null;
  }

  // ===========================================================================
  // Existing selections

  /// [Rect]s for all existing [MultiSelectText.selections]
  Map<MultiSelectTextSelection, List<Rect>> _rectBySelection = {};

  void _storeRectsBySelection() {
    if (_renderParagraph == null) {
      _rectBySelection = const {};
      return;
    }

    _rectBySelection = {
      for (final r in widget.selections)
        r: _getRectsForSelection(TextSelection(
          baseOffset: r.textRange.start,
          extentOffset: r.textRange.end,
        )),
    };
  }

  // ===========================================================================
  // Ongoing new selections

  /// An ongoing selection created via [_onPanStart] etc.
  TextSelection? _ongoingSelection;

  /// Stored [_getRectsForSelection] for [_ongoingSelection]
  List<Rect> _ongoingSelectionRects = [];

  /// The character index immediately following the selections start position.
  /// § "ABC"(0) => "|ABC"
  /// § "ABC"(3) => "ABC|"
  ///
  /// See [TextPosition.offset]
  int? get _ongoingSelectionBaseOffset => _ongoingSelection?.baseOffset;

  void _onUserSelectionChange(TextSelection textSelection) {
    widget.onNewSelectionUpdate?.call(textSelection);
    setState(() {
      _ongoingSelection = textSelection;
      _ongoingSelectionRects = _getRectsForSelection(_ongoingSelection!);
    });
  }

  void _onPanStart(DragStartDetails details) => _onUserSelectionChange(
        TextSelection.collapsed(
          offset: _getPositionForOffset(details.localPosition).offset,
        ),
      );

  void _onPanUpdate(DragUpdateDetails details) => _onUserSelectionChange(
        TextSelection(
          baseOffset: _ongoingSelectionBaseOffset!,
          extentOffset: _getPositionForOffset(details.localPosition).offset,
        ),
      );

  void _onPanCancel() => setState(() {
        _ongoingSelection = null;
        _ongoingSelectionRects = [];
      });

  void _onPanEnd(_) {
    widget.onNewSelectionDone?.call(_ongoingSelection!);
    setState(() {
      _ongoingSelection = null;
      _ongoingSelectionRects = [];
    });
  }

  // ===========================================================================
  // Lifecylce

  @override
  void initState() {
    super.initState();
    _storeTextLenght();
  }

  @override
  void didUpdateWidget(MultiSelectText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.textSpan != widget.textSpan) {
      _storeTextLenght();
    }

    if (!listEquals(oldWidget.selections, widget.selections)) {
      _storeRectsBySelection();
    }
  }

  // =================================================

  @override
  Widget build(BuildContext context) {
    return ConstraintsChangedNotifier(
      onConstraintsChanged: (_, __) => setState(_storeRectsBySelection),
      child: Stack(
        children: [
          Listener(
            onPointerUp: (event) {
              final _hoveredRect = _getRectUnderOffset(event.localPosition);
              final _textPosition = _getPositionForOffset(event.localPosition);
              if (_hoveredRect != null) {
                widget.onTapUpSelection?.call(_textPosition, _hoveredRect);
              }
            },
            child: GestureDetector(
              supportedDevices: {
                PointerDeviceKind.invertedStylus,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.touch,
                //PointerDeviceKind.trackpad  <-- Explicitly not this; trackpad scroll
              },
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onPanCancel: _onPanCancel,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  for (final selection in _rectBySelection.entries)
                    selection.key.build?.call(selection.value) ??
                        CustomPaint(
                          painter: SelectableTextBoxPainter(
                            color: Colors.blue.withAlpha(100),
                            rects: selection.value,
                            fill: true,
                          ),
                        ),
                  if (_ongoingSelectionRects.isNotEmpty)
                    CustomPaint(
                      painter: SelectableTextBoxPainter(
                        color: Colors.blue.withAlpha(100),
                        rects: _ongoingSelectionRects,
                        fill: true,
                      ),
                    ),
                  RichText(
                    key: _richTextKey,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [widget.textSpan],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// =============================================================================
// =============================================================================
// =============================================================================

class SelectableTextBoxPainter extends CustomPainter {
  SelectableTextBoxPainter({
    required Color color,
    required List<Rect> rects,
    bool fill = true,
    Radius? cornerRadius,
  })  : _rects = rects,
        _fill = fill,
        _paint = Paint()..color = color,
        _cornerRadius = cornerRadius;

  final bool _fill;
  final List<Rect> _rects;
  final Paint _paint;
  final Radius? _cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = _fill ? PaintingStyle.fill : PaintingStyle.stroke;
    for (final rect in _rects) {
      if (_cornerRadius == null) {
        canvas.drawRect(rect, _paint);
      } else {
        canvas.drawRRect(RRect.fromRectAndRadius(rect, _cornerRadius!), _paint);
      }
    }
  }

  @override
  bool shouldRepaint(SelectableTextBoxPainter oldDelegate) {
    return true;
  }
}
