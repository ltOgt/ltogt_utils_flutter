import 'package:flutter/widgets.dart';
import 'dart:async';

class RenderHelper {
  /// Add a callback to be executed on the next frame.
  ///
  /// This can be useful if you need to call e.g. [RenderHelper.getSize]
  static bool addPostFrameCallback(Function(Duration) callback) {
    final instance = WidgetsBinding.instance;

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
  ///
  /// NOTE:
  /// See [getRectWithSafeArea] when used under [SafeArea]
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

  static Future<void> get nextFrameFuture async {
    Completer completer = Completer();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => completer.complete());
    await completer.future;
  }

  /// Adjust [getRect] to provide expected [Rect] under [SafeArea].
  ///
  /// In case you use [SafeArea], the returned [Rect] may be not be in line with
  /// the applications coordinate system deeper in the tree
  /// (such as in an [Overlay]).
  ///
  /// `MediaQuery.of(context).padding` will probably be [EdgeInsets.zero]
  /// if queried from a context below [SafeArea] (which overwrites this padding).
  ///
  /// In this case you may need to cache one of two things ABOVE the [SafeArea]
  /// - the actual [EdgeInsets] from [MediaQuery] with a context above [SafeArea]
  /// - a [rootContext] above, which can then be used to get the correct padding.
  static ({Rect? rect, Size screenSize}) getRectWithSafeArea({
    required GlobalKey globalKey,
    required BuildContext rootContext,
  }) {
    final data = MediaQuery.of(rootContext);
    final padding = data.padding;

    final adjustedScreenSize = Size(
      data.size.width - padding.horizontal,
      data.size.height - padding.vertical,
    );

    final rect = getRect(globalKey: globalKey);

    if (rect == null) {
      return (rect: null, screenSize: adjustedScreenSize);
    }

    final adjustedRect = rect.shift(
      -Offset(padding.left, padding.top),
    );

    return (rect: adjustedRect, screenSize: adjustedScreenSize);
  }
}
