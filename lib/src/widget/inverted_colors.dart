import 'package:flutter/widgets.dart';

/// Uses [ColorFiltered] with [ColorFilter] inverse matrix to invert
/// all colors for the subtree [child].
class InvertedColors extends StatelessWidget {
  final Widget child;
  final bool isActive;

  const InvertedColors({
    super.key,
    required this.child,
    this.isActive = true,
  });

  /// See [ColorFilter] documentation example
  static const ColorFilter invert = ColorFilter.matrix(<double>[
    -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0
  ]);
  static const ColorFilter identity = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: isActive ? invert : identity,
      child: child,
    );
  }
}
