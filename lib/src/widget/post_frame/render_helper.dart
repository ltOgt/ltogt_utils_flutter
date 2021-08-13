import 'package:flutter/widgets.dart';

class RenderHelper {
  /// Add a callback to be executed on the next frame.
  ///
  /// This can be useful if you need to call e.g. [RenderHelper.getSize]
  ///
  /// Returns true if sucessfull, false if [WidgetsBinding.instance] is null.
  static bool addPostFrameCallback(Function(Duration) callback) {
    final instance = WidgetsBinding.instance;
    if (instance == null) return false;

    instance.addPostFrameCallback(callback);
    return true;
  }

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

  /// Get the global size (flutter window) and position (top-left from flutter window) of a widget with key=[globalKey].
  ///
  /// Returns null if the widget has no context or no RenderBox.
  ///
  /// Typically called in [initState] with [WidgetsBinding.instance?.addPostFrameCallback]
  static Rect? getRect({required GlobalKey globalKey}) {
    if (globalKey.currentContext == null) {
      return null;
    }

    final RenderObject? renderObject = globalKey.currentContext!.findRenderObject();
    if (renderObject == null || !(renderObject is RenderBox)) {
      return null;
    }

    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  static RenderObject? getRenderObject({required GlobalKey globalKey}) {
    return globalKey.currentContext?.findRenderObject();
  }
}
