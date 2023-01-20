import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

/// Reports the [BoxConstraints] from [LayoutBuilder.builder] with one frame delay
/// using [onConstraintsChanged].
class ConstraintsChangedNotifier extends StatefulWidget {
  const ConstraintsChangedNotifier({
    super.key,
    required this.onConstraintsChanged,
    this.child,
    this.build,
  });

  /// Called with one frame delay.
  /// Exposes the constraints before and during the last frame.
  final void Function(BoxConstraints? before, BoxConstraints during) onConstraintsChanged;

  /// Return [child] through [LayoutBuilder.builder].
  final Widget? child;

  /// If [child] is `null`, [build] through [LayoutBuilder.builder].
  final Widget Function(BoxConstraints constraints)? build;

  @override
  State<ConstraintsChangedNotifier> createState() => _ConstraintsChangedNotifierState();
}

class _ConstraintsChangedNotifierState extends State<ConstraintsChangedNotifier> {
  BoxConstraints? lastConstraints;

  void _checkConstraints(BoxConstraints constraints) async {
    if (constraints != this.lastConstraints) {
      await RenderHelper.nextFrameFuture;
      if (mounted) {
        widget.onConstraintsChanged(this.lastConstraints, constraints);
        setState(() => this.lastConstraints == constraints);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        _checkConstraints(constraints);
        return widget.child ?? widget.build?.call(constraints) ?? SizedBox();
      },
    );
  }
}
