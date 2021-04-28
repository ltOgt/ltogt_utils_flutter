import 'package:flutter/widgets.dart';

/// Conditionally wrap a subtree with a parent widget without breaking the code tree.
///
/// [condition]: the condition depending on which the subtree [child] is wrapped with the parent.
/// [child]: The subtree that should always be build.
/// [conditionalParentBuilder]: builds the parent with the subtree [child].
///
/// ___________
/// Usage:
/// ```dart
/// return ConditionalParentWidget(
///   condition: shouldIncludeParent,
///   child: Widget1(
///     child: Widget2(
///       child: Widget3(),
///     ),
///   ),
///   conditionalParentBuilder: (Widget child) => SomeParentWidget(child: child),
///);
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
/// return shouldIncludeParent ? SomeParentWidget(child: child) : child;
/// ```
///
class ConditionalParentWidget extends StatelessWidget {
  const ConditionalParentWidget({
    Key? key,
    required this.condition,
    required this.child,
    required this.conditionalParentBuilder,
  }) : super(key: key);

  final Widget child;
  final bool condition;
  final Widget Function(Widget child) conditionalParentBuilder;

  @override
  Widget build(BuildContext context) {
    return condition ? this.conditionalParentBuilder(this.child) : this.child;
  }
}
