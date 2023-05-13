import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class DecoratedOverflowScroll extends StatelessWidget {
  const DecoratedOverflowScroll({
    Key? key,
    required this.axis,
    required this.maxAxisSize,
    required this.child,
  }) : super(key: key);

  final Axis axis;
  final double? maxAxisSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBoxAxis(
      axis: axis,
      mainAxisSize: maxAxisSize,
      child: ScrollNotificationBuilder(
        builder: (metrics) => Stack(
          children: [
            ListView(
              physics: metrics?.isInsideOnly ?? false ? NeverScrollableScrollPhysics() : null,
              scrollDirection: axis,
              shrinkWrap: true,
              children: [
                // TODO would like to nest scroll views on two axis; try adding another listview here for a nice error message
                child
              ],
            ),
            if (metrics?.isBefore ?? false)
              PositionedOnEdgeX.top(child: Container(width: 10, height: 10, color: Colors.red)),
            if (metrics?.isAfter ?? false)
              PositionedOnEdgeX.bottom(child: Container(width: 10, height: 10, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
