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
    int? maxLines,
  }) {
    final painter = (customPainter?.call(textSpan) ??
        TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
          textWidthBasis: TextWidthBasis.longestLine,
        ))
      ..layout(
        minWidth: minWidth,
        maxWidth: maxWidth,
      );
    return painter.size;
  }
}
