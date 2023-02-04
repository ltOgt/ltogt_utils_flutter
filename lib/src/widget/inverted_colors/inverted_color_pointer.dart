import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/src/widget/builder/hover_builder.dart';
import 'package:ltogt_utils_flutter/src/widget/inverted_colors/inverted_colors_clip_stack.dart';

/// Uses [InvertedColorsClipStack] as a pointer effect.
class InvertedColorsPointer extends StatelessWidget {
  const InvertedColorsPointer({
    super.key,
    this.child,
    this.builder,
    required this.cursorSize,
    this.isEnabled = true,
  }) : assert((child == null) != (builder == null), "Provide either child xor builder");

  /// See [InvertedColorsClipStack.child]
  final Widget? child;

  /// See [InvertedColorsClipStack.builder]
  final Widget Function(bool isOverlay)? builder;

  /// The size of the cursor.
  /// The color inversion effect will be a [Rect] centered on the pointer with this size.
  final Size cursorSize;

  /// Can be used to disable the pointer effect without removing this widget from the tree
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      opaque: true,
      builderWithEvent: (isHovering, event) {
        return InvertedColorsClipStack(
          isVisible: (isEnabled && isHovering && event != null),
          visibleAnimationDuration: isEnabled ? Duration.zero : const Duration(milliseconds: 200),
          localRect: Rect.fromCenter(
            center: event?.localPosition ?? Offset.zero,
            width: cursorSize.width,
            height: cursorSize.height,
          ),
          builder: builder,
          child: child,
        );
      },
    );
  }
}
