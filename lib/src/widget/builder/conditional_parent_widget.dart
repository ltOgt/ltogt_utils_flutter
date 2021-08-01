import 'package:flutter/widgets.dart';

class ConditionalParentWidget extends StatelessWidget {
  /// Conditionally wrap a subtree with a parent widget without breaking the code tree.
  ///
  /// [condition]: controls how/whether the [child] is wrapped.
  /// [child]: The subtree that should always be build.
  /// [parentBuilder]: builds the parent with the subtree [child] if [condition] is true.
  /// [parentBuilder]?: child returned directly when this is null.
  ///                   builds the parent with the subtree [child] if [condition] is false
  ///
  ///
  /// ___________
  /// Tree will look like:
  /// ```dart
  /// return SomeWidget(
  ///   child: SomeOtherWidget(
  ///     child: ConditionalParentWidget(
  ///       condition: shouldIncludeParent,
  ///       parentBuilder: (Widget child) => SomeParentWidget(child: child),
  ///       child: Widget1(
  ///         child: Widget2(
  ///           child: Widget3(),
  ///         ),
  ///       ),
  ///     ),
  ///   ),
  /// );
  /// ```
  ///
  /// ___________
  /// Instead of:
  /// ```dart
  /// Widget child = Widget1(
  ///   child: Widget2(
  ///     child: Widget3(),
  ///   ),
  /// );
  ///
  /// return SomeWidget(
  ///   child: SomeOtherWidget(
  ///     child: shouldIncludeParent
  ///       ? SomeParentWidget(child: child)
  ///       : child
  ///   ),
  /// );
  /// ```
  ///
  const ConditionalParentWidget({
    Key? key,
    required this.condition,
    required this.parentBuilder,
    this.parentBuilderElse,
    required this.child,
  }) : super(key: key);

  /// The [child] which should be conditionally wrapped.
  final Widget child;

  /// The [condition] which controls how/whether the [child] is wrapped.
  final bool condition;

  /// Builder to wrap [child] when [condition] is `true`.
  final Widget Function(Widget child) parentBuilder;

  /// Optional builder to wrap [child] when [condition] is `true`.
  ///
  /// [child] is returned directly when this is `null`.
  final Widget Function(Widget child)? parentBuilderElse;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return parentBuilder(child);
    }

    if (parentBuilderElse == null) {
      return child;
    }

    return parentBuilderElse!(child);
  }
}
