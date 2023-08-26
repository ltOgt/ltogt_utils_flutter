import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils_flutter/src/widget/post_frame/render_helper.dart';

/// Two images [childA] and [childB] are stacked and clipped in disjoined halfs
/// at [initialFraction].
///
/// Users can drag on the stack to change the [initialFraction].
class ClipDragger extends StatefulWidget {
  const ClipDragger({
    super.key,
    this.initialFraction = 0.5,
    required this.childA,
    required this.childB,
  });

  final double initialFraction;

  final Widget childA;
  final Widget childB;

  @override
  State<ClipDragger> createState() => _ClipDraggerState();
}

// TODO for now from left to right
class _ClipDraggerState extends State<ClipDragger> {
  late double _fraction = widget.initialFraction;
  double get _fractionAsAlign => _fraction * 2 - 1;

  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, __) {
      return GestureDetector(
        onHorizontalDragUpdate: (details) {
          final size = RenderHelper.getSize(globalKey: _key)!;
          setState(
            () => _fraction = NumHelper.bounded(
              details.localPosition.dx / size.width,
              0,
              1,
            ),
          );
        },
        child: Stack(
          key: _key,
          children: [
            ClipPath(
              clipper: FractionClipper(0, _fraction),
              child: widget.childA,
            ),
            ClipPath(
              clipper: FractionClipper(_fraction, 1),
              child: widget.childB,
            ),
            Align(
              alignment: Alignment(_fractionAsAlign, 0),
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FractionClipper extends CustomClipper<Path> {
  final double fractionStart;
  final double fractionEnd;

  FractionClipper(this.fractionStart, this.fractionEnd);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * fractionStart, 0);
    path.lineTo(size.width * fractionStart, size.height);
    path.lineTo(size.width * fractionEnd, size.height);
    path.lineTo(size.width * fractionEnd, 0); // Bottom left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant FractionClipper oldClipper) {
    return oldClipper.fractionStart != fractionStart //
        ||
        oldClipper.fractionEnd != fractionEnd;
  }
}
