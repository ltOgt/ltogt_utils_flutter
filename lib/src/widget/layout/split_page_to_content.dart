import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

typedef Page = Widget;
typedef Pages = List<Page>;
typedef Content = Widget;

enum SplitAxis {
  left_right(Axis.horizontal),
  top_bottom(Axis.vertical);

  final Axis axis;
  const SplitAxis(this.axis);

  SplitAxis get next => SplitAxis.values[(index + 1) % SplitAxis.values.length];
  bool get isLeftRight => this == left_right;
  bool get isTopBottom => this == top_bottom;
}

/// Split-Screen layout on one [Axis] with:
/// - Multiple "Pages" in a scrollable area on one side
/// - "Content" of the one active page on the other side
///
/// Think of a PDF viewer as example, altough this layout can be used more broadly
class SplitPageToContent extends StatelessWidget {
  /// The axis on which to split.
  final SplitAxis splitAxis;

  /// Whether the [Pages] are left/top depending on [splitAxis],
  /// otherwise right/bottom.
  final bool isPagesFirst;

  /// The fraction (0..1) of the cross axis where the separator should be centered.
  final double splitFraction;

  /// The widget seperating [Pages] and [Content] (centered on [splitFraction]).
  final Widget? splitWidget;

  /// Callback for when user drags on [splitWidget].
  final void Function(double splitFraction)? splitFractionOnUpdate;

  /// Required [GlobalKey] for [splitFractionOnUpdate].
  final GlobalKey? splitFractionKey;

  // ===========================================================================
  // ===========================================================================
  // ===========================================================================

  /// The total number of [Pages]
  final int pageCount;

  /// {@macro flutter.widgets.list_view.itemExtent}
  final double? pageExtent;

  /// The currently selected [Page]
  final int? pageActiveIndex;

  /// Callback for setting the new [pageActiveIndex] after a [Page] was clicked.
  final void Function(int? pageActiveIndex)? pageOnTap;

  /// Build the [Pages].
  final Page Function(int pageIndex) pageBuild;

  final ScrollController? pageScrollController;

  // ===========================================================================
  // ===========================================================================
  // ===========================================================================

  /// Build the [Content] for the active [Page]
  final Content Function() contentBuild;

  final Alignment contentAlignment;

  // ===========================================================================
  // ===========================================================================
  // ===========================================================================

  SplitPageToContent({
    this.splitAxis = SplitAxis.left_right,
    this.isPagesFirst = true,
    required this.splitFraction,
    this.splitWidget,
    this.splitFractionOnUpdate,
    this.splitFractionKey,
    required this.pageCount,
    this.pageExtent,
    this.pageActiveIndex,
    this.pageOnTap,
    required this.pageBuild,
    this.pageScrollController,
    required this.contentBuild,
    this.contentAlignment = Alignment.center,
  })  : assert(splitFraction <= 1 && splitFraction >= 0),
        assert(
          splitFractionOnUpdate == null || splitFractionKey != null,
          "Need a GlobalKey for the fraction drag",
        );

  @override
  Widget build(BuildContext context) {
    final _pageFraction = isPagesFirst ? splitFraction : 1 - splitFraction;
    final _contentFraction = 1 - _pageFraction;

    return RowOrColumn(
      key: splitFractionKey,
      axis: splitAxis.axis,
      children: useValue([
        // ------------------------------------- Pages
        Flexible(
          flex: (_pageFraction * 100).round(),
          child: ListView.builder(
            itemCount: pageCount,
            itemExtent: pageExtent,
            itemBuilder: (c, i) => ConditionalParentWidget(
              condition: pageOnTap != null,
              child: pageBuild(i),
              parentBuilder: (child) => GestureDetector(
                onTap: () => pageOnTap!(i),
                child: child,
              ),
            ),
            controller: pageScrollController,
            scrollDirection: splitAxis.next.axis,
          ),
        ),
        // ------------------------------------- Split
        if (splitWidget != null || splitFractionOnUpdate != null)
          ConditionalParentWidget(
            condition: splitFractionOnUpdate != null,
            child: splitWidget ??
                MouseRegion(
                  cursor: splitAxis.isLeftRight ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow,
                  child: (splitAxis.isLeftRight //
                      ? Container(width: 4, height: double.infinity, color: Color(0xFF000000))
                      : Container(height: 4, width: double.infinity, color: Color(0xFF000000))),
                ),
            parentBuilder: (child) => GestureDetector(
              // i.e. NOT trackpad
              supportedDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus},
              onHorizontalDragUpdate: (details) {
                if (splitFractionKey == null) return;
                final r = RenderHelper.getRect(globalKey: splitFractionKey!);
                if (r == null) return;

                final dimension = splitAxis.isLeftRight ? r.width : r.height;
                final localPosition = details.globalPosition - r.topLeft;
                final position = splitAxis.isLeftRight ? localPosition.dx : localPosition.dy;
                final newFraction = position / dimension;

                splitFractionOnUpdate!(max(0.1, min(0.9, newFraction)));
              },
              onHorizontalDragEnd: (details) {
                print("end");
              },
              child: child,
            ),
          ),
        // ------------------------------------- Content
        Flexible(
          flex: (_contentFraction * 100).round(),
          child: Align(
            alignment: contentAlignment,
            child: contentBuild(),
          ),
        ),
      ], (value) => isPagesFirst ? value : value.reversed.toList()),
    );
  }
}
