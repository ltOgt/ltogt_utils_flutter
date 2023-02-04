import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

/// Wrap [child] or [builder] with [InvertedColors] if [hasFocus].
///
/// Also use [InvertedColorsPointer] as a pointer effect on hover.
class InvertedColorFocusable extends StatelessWidget {
  const InvertedColorFocusable({
    super.key,
    this.child,
    this.builder,
    required this.hasFocus,
    this.cursorSize = cursorSizeDefault,
    this.enablePointerEffectWhenFocused = false,
  }) : assert((child == null) != (builder == null), "Provide either child or build");

  final Widget? child;
  final Widget Function(bool isOverlay)? builder;

  /// The size of the [InvertedColorsPointer].
  ///
  /// Defaults to small width and practically infinite height (although not actually infinite)
  final Size cursorSize;
  static const cursorSizeDefault = const Size(16, 100000);

  /// Whether the widget has focus and should therefore have [InvertedColors].
  ///
  /// See e.g. [FocusBuilder] for an easy way to provide this value.
  final bool hasFocus;

  /// Whether to apply the [InvertedColorsPointer] even when the [child]/[builder] has focus.
  final bool enablePointerEffectWhenFocused;

  @override
  Widget build(BuildContext context) {
    return InvertedColors(
      isActive: hasFocus,
      child: InvertedColorsPointer(
        isEnabled: !hasFocus || enablePointerEffectWhenFocused,
        cursorSize: cursorSize,
        child: child,
        builder: builder,
      ),
    );
  }
}
