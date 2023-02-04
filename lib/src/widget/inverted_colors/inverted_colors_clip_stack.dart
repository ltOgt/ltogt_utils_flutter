import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/src/widget/clip/custom_clip_rect.dart';
import 'package:ltogt_utils_flutter/src/widget/inverted_colors/inverted_colors.dart';

/// {@template invertedColorsClipStack}
/// Render a color inversion on top of [child] (or [builder]).
///
/// The inverted region is defined as [localRect] and
/// uses the same widget with a [ClipRect].
///
/// Use [builder] instead of [child] if the subtree has controllers or similar
/// objects that can only be associated with one widget.
/// {@endtemplate}
class InvertedColorsClipStack extends StatelessWidget {
  /// {@macro invertedColorsClipStack}
  const InvertedColorsClipStack({
    super.key,
    this.child,
    this.builder,
    required this.isVisible,
    required this.localRect,
    this.visibleAnimationDuration = Duration.zero,
    this.visibleAnimationCurve = Curves.linear,
  }) : assert((child == null) != (builder == null), "Provide either child xor builder");

  /// Used both as the base and the inverted highlight through clipping on [localRect].
  ///
  /// See [builder] for if your subtree contains controllers or similar objects
  /// that can only be associated with one widget.
  final Widget? child;

  /// Used as the base (with `isOverlay == false`) and the inverted highlight
  /// through clipping on [localRect] (with `isOverlay == true`).
  final Widget Function(bool isOverlay)? builder;

  /// Toggle the (animated) visibility of the inversion clip.
  ///
  /// See [visibleAnimationDuration] and [visibleAnimationCurve].
  ///
  /// To disable the clip without animation, simply set [visibleAnimationDuration]
  /// to [Duration.zero]
  final bool isVisible;
  final Duration visibleAnimationDuration;
  final Curve visibleAnimationCurve;

  /// The [Rect] inside the [child] that should be inverted.
  final Rect localRect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child ?? builder!(false),
        IgnorePointer(
          child: GestureDetector(
            // Simply to not have any kind of scroll effects on the inverted part
            onPanStart: (_) {},
            onPanUpdate: (_) {},
            child: AnimatedOpacity(
              opacity: isVisible ? 1 : 0,
              duration: visibleAnimationDuration,
              curve: visibleAnimationCurve,
              child: ClipRectLocalRect(
                rect: localRect,
                child: InvertedColors(
                  child: child ?? builder!(true),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
