import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ltogt_utils/ltogt_utils.dart';

/// A widget to take a Screenshot of [child] via [trigger]
class ScreenshotSubtree extends StatelessWidget {
  const ScreenshotSubtree({
    super.key,
    required this.child,
    required this.trigger,
  });

  /// The subtree that should be captured via [trigger.takeScreenshot]
  final Widget child;

  /// Controller-like object to get a screenshot via [RepaintBoundary]
  final ScreenshotSubtreeTrigger trigger;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: trigger.subtreeKey,
      child: child,
    );
  }
}

/// Controller-Like object to [takeScreenshot] of the receiving [ScreenshotSubtree].
class ScreenshotSubtreeTrigger {
  /// [GlobalKey] given to a [RepaintBoundary] inside [ScreenshotSubtree].
  final subtreeKey = GlobalKey();

  /// Take an image of the subtree wrapped by the [ScreenshotSubtree] this object was passed to.
  Future<ScreenshotImageData> takeScreenshot({double pixelRatio = 1.0}) async {
    assert(
      subtreeKey.currentContext != null,
      "ScreenshotSubtreeController is not passed to any ScreenshotSubtree",
    );

    final boundary = subtreeKey.currentContext!.findRenderObject()!;
    boundary as RenderRepaintBoundary;

    return ScreenshotImageData(
      await boundary.toImage(pixelRatio: pixelRatio),
    );
  }
}

/// Accessor for [ui.Image] data with [pngByteFuture] and [base64Future].
class ScreenshotImageData {
  final ui.Image image;

  ScreenshotImageData(this.image);

  late Future<Uint8List?> pngByteFuture = image
      .toByteData(
        format: ui.ImageByteFormat.png,
      )
      .then(
        (bd) => bd?.buffer.asUint8List(),
      );

  late Future<String?> base64Future = pngByteFuture.then(
    (v) => ifNotNull(v, base64Encode),
  );
}
