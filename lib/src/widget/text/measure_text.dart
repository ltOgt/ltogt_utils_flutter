import 'package:flutter/painting.dart';

class TextSizeUtil {
  /// Thin wrapper for text painter.
  ///
  /// Main utility of this is that i keep forgetting how this is done.
  static Size measure(
    TextSpan textSpan, {
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    TextPainter Function(TextSpan textSpan)? customPainter,
  }) {
    final painter = (customPainter?.call(textSpan) ?? TextPainter(text: textSpan))
      ..layout(
        minWidth: minWidth,
        maxWidth: maxWidth,
      );
    return painter.size;
  }
}
