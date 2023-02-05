import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/src/extensions/positioned_on_edge_x.dart';
import 'package:ltogt_utils_flutter/src/widget/builder/conditional_parent_widget.dart';

class DecoratedScrollableDetails {
  final ScrollMetrics metrics;

  DecoratedScrollableDetails._(this.metrics);
  static DecoratedScrollableDetails? orNull(ScrollMetrics? m) => m == null //
      ? null
      : DecoratedScrollableDetails._(m);

  bool get isBefore => metrics.extentBefore > 0;
  bool get isAfter => metrics.extentAfter > 0;
  bool get isInsideOnly => !isBefore && !isAfter;
}

class DecoratedScrollable extends StatefulWidget {
  const DecoratedScrollable({
    Key? key,
    required this.child,
    required this.scrollVertical,
    required this.scrollHorizontal,
    this.childIsScrollable = false,
    this.buildDecoration = buildDecorationDefault,
    this.controllerHorizontal,
    this.controllerVertical,
    this.centerChild = false,
  }) : super(key: key);

  /// Sub-tree that should be made scrollable.
  ///
  /// (Unless [childIsScrollable])
  final Widget child;

  /// Dont put [child] into [SingleChildScrollView].
  ///
  /// Use this when your [child] is a [Scrollable] that
  /// uses [controllerHorizontal] and/or [controllerVertical].
  final bool childIsScrollable;

  final bool scrollVertical;
  final bool scrollHorizontal;

  final Widget Function(DecoratedScrollableDetails? v, DecoratedScrollableDetails? h) buildDecoration;

  final ScrollController? controllerVertical;
  final ScrollController? controllerHorizontal;

  final bool centerChild;

  @override
  State<DecoratedScrollable> createState() => _DecoratedScrollableState();

  static Widget buildDecorationDefault(
    DecoratedScrollableDetails? v,
    DecoratedScrollableDetails? h,
  ) {
    const shadow = BoxShadow(blurRadius: 4, spreadRadius: 1);
    return Stack(
      children: [
        // Vertical
        if (v != null && v.isBefore) //
          PositionedOnEdgeX.top(
            Container(
              decoration: BoxDecoration(boxShadow: [shadow]),
              height: 1,
              width: double.infinity,
            ),
          ),
        if (v != null && v.isAfter) //
          PositionedOnEdgeX.bottom(
            Container(
              decoration: BoxDecoration(boxShadow: [shadow]),
              height: 1,
              width: double.infinity,
            ),
          ),
        // Horizontal
        if (h != null && h.isBefore) //
          PositionedOnEdgeX.left(
            Container(
              decoration: BoxDecoration(boxShadow: [shadow]),
              width: 1,
              height: double.infinity,
            ),
          ),
        if (h != null && h.isAfter) //
          PositionedOnEdgeX.right(
            Container(
              decoration: BoxDecoration(boxShadow: [shadow]),
              width: 1,
              height: double.infinity,
            ),
          ),
      ],
    );
  }
}

class _DecoratedScrollableState extends State<DecoratedScrollable> {
  ScrollMetrics? verticalMetrics;
  ScrollMetrics? horizontalMetrics;

  late ScrollController verticalCtrl;
  late ScrollController horizontalCtrl;

  @override
  void initState() {
    super.initState();
    verticalCtrl = widget.controllerVertical ?? ScrollController();
    horizontalCtrl = widget.controllerHorizontal ?? ScrollController();
  }

  @override
  void didUpdateWidget(covariant DecoratedScrollable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controllerHorizontal != widget.controllerHorizontal) {
      if (oldWidget.controllerHorizontal == null) {
        horizontalCtrl.dispose();
      }
      horizontalCtrl = widget.controllerHorizontal ?? ScrollController();
    }
    if (oldWidget.controllerVertical != widget.controllerVertical) {
      if (oldWidget.controllerVertical == null) {
        verticalCtrl.dispose();
      }
      verticalCtrl = widget.controllerVertical ?? ScrollController();
    }
  }

  @override
  void dispose() {
    if (widget.controllerVertical == null) {
      verticalCtrl.dispose();
    }
    if (widget.controllerHorizontal == null) {
      horizontalCtrl.dispose();
    }
    super.dispose();
  }

  bool _onNotification(Notification? notification) {
    if (!mounted) return false;

    ScrollMetrics? metrics;
    if (notification is ScrollNotification) {
      metrics = notification.metrics;
    } else if (notification is ScrollMetricsNotification) {
      metrics = notification.metrics;
    }

    if (metrics != null) {
      switch (metrics.axis) {
        // NOTE that these checks (before/after) would need to be switched if we were to reverse the scrollable
        case Axis.horizontal:
          horizontalMetrics = metrics;
          break;
        case Axis.vertical:
          verticalMetrics = metrics;
          break;
      }

      // Notification might be send during layout, so we sadly need to schedule a post frame callback to setState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      // Clip shadows from decorations
      child: ClipRect(
        child: Stack(
          children: [
            // CONTENT
            Positioned.fill(
              child: ConditionalParentWidget(
                condition: widget.centerChild,
                parentBuilder: (child) => Center(child: child),
                child: widget.childIsScrollable
                    ? widget.child
                    : SingleChildScrollView(
                        scrollDirection: widget.scrollVertical ? Axis.vertical : Axis.horizontal,
                        controller: widget.scrollVertical ? verticalCtrl : horizontalCtrl,
                        child: !(widget.scrollVertical && widget.scrollHorizontal) //
                            ? widget.child
                            : SingleChildScrollView(
                                // if two axis, then the previous one is vertical
                                // if one axis, the previous is the only one with the correct axis
                                scrollDirection: Axis.horizontal,
                                controller: horizontalCtrl,
                                child: widget.child,
                              ),
                      ),
              ),
            ),
            // DECORATION
            widget.buildDecoration(
              DecoratedScrollableDetails.orNull(verticalMetrics),
              DecoratedScrollableDetails.orNull(horizontalMetrics),
            ),
          ],
        ),
      ),
    );
  }
}
