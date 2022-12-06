import 'dart:async';

import 'package:flutter/material.dart';
import 'overlay_manager.dart';
import 'post_frame/render_helper.dart';

/// Small utility to measure a widget before actually putting it on screen.
///
/// This can be helpful e.g. for positioning context menus based on the size they will take up.
///
/// NOTE: This will take one frame!
/// To circumvent a one-frame delay, you could e.g. request the measurement before you
/// start an opening animation with estimated target size, which is adjusted in the next frame
/// once the measurement result is available.
///
/// NOTE: Use sparingly, since this takes a complete layout and sizing pass for the subtree you
/// want to measure.
///
/// Uses an invisible overlay with optional [constraints] (defaults to unconstraint)
class MeasureUtil {
  final BoxConstraints? constraints;
  late final OverlayManager manager;
  late final GlobalKey key;
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  MeasureUtil({
    required Widget Function(BuildContext context) builder,
    this.constraints,
  }) {
    this.key = GlobalKey(debugLabel: "Measure Util Key");
    this.manager = OverlayManager(
      overlayBuilder: (context) => Center(
        child: OverflowBox(
          maxHeight: constraints?.maxWidth ?? double.infinity,
          maxWidth: constraints?.maxWidth ?? double.infinity,
          minHeight: constraints?.minHeight,
          minWidth: constraints?.minWidth,
          child: Opacity(
            opacity: 0,
            child: KeyedSubtree(
              key: key,
              child: builder(context),
            ),
          ),
        ),
      ),
    );
  }

  void dispose() {
    manager.dispose();
    _isDisposed = true;
  }

  Future<Size?> measure(BuildContext context) async {
    assert(!_isDisposed, "Dont call measure after dispose");

    await manager.show(context);

    // wait one frame
    await RenderHelper.nextFrameFuture;

    final size = RenderHelper.getSize(globalKey: this.key);
    manager.hide(context);
    return size;
  }
}
