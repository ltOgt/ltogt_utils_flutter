import 'package:flutter/widgets.dart';

/// Wrapper around [ClipRect] with an actual [rect] that uses
/// [CustomClipLocalRect] as [ClipRect.clipper]
class ClipRectLocalRect extends StatelessWidget {
  const ClipRectLocalRect({
    Key? key,
    required this.child,
    this.clipBehavior = Clip.hardEdge,
    required this.rect,
  }) : super(key: key);

  final Widget child;
  final Clip clipBehavior;
  final Rect rect;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: clipBehavior,
      clipper: CustomClipLocalRect(localRect: rect),
      child: child,
    );
  }
}

/// [CustomClipper] that simply uses [localRect] for [getClip].
///
/// Used by [ClipRectLocalRect].
class CustomClipLocalRect extends CustomClipper<Rect> {
  Rect localRect;
  CustomClipLocalRect({
    required this.localRect,
  });

  @override
  getClip(Size size) => //
      localRect;

  @override
  bool shouldReclip(covariant CustomClipLocalRect oldClipper) => //
      oldClipper.localRect != localRect;
}
