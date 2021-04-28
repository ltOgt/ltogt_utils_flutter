import 'package:flutter/widgets.dart';

class RenderHelper {
  /// Get the global size (flutter window) of a widget with key=[globalKey].
  ///
  /// Returns null if the widget has no context or no RenderBox.
  ///
  /// Typically called in [initState] with [WidgetsBinding.instance?.addPostFrameCallback]
  static Size? getSize({required GlobalKey globalKey}) {
    if (globalKey.currentContext == null) {
      return null;
    }

    final RenderObject? renderObject = globalKey.currentContext!.findRenderObject();
    if (renderObject == null || !(renderObject is RenderBox)) {
      return null;
    }

    return renderObject.size;
  }

  /// Get the global position (top-left from flutter window) of a widget with key=[globalKey].
  ///
  /// Returns null if the widget has no context or no RenderBox.
  ///
  /// Typically called in [initState] with [WidgetsBinding.instance?.addPostFrameCallback]
  static Offset? getPosition({required GlobalKey globalKey}) {
    if (globalKey.currentContext == null) {
      return null;
    }

    final RenderObject? renderObject = globalKey.currentContext!.findRenderObject();
    if (renderObject == null || !(renderObject is RenderBox)) {
      return null;
    }

    return renderObject.localToGlobal(Offset.zero);
  }
}
