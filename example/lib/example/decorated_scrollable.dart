import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const DecoratedScrollableExample());
}

class DecoratedScrollableExample extends StatefulWidget {
  const DecoratedScrollableExample({Key? key}) : super(key: key);

  @override
  State<DecoratedScrollableExample> createState() => _DecoratedScrollableExampleState();
}

class _DecoratedScrollableExampleState extends State<DecoratedScrollableExample> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cached Builder Example',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: DecoratedScrollable(
          scrollHorizontal: true,
          scrollVertical: true,
          child: Column(
            children: ListGenerator.forRange(
              to: 40,
              generator: (i) => SizedBox(
                height: 100,
                child: Row(
                    children: ListGenerator.forRange(
                  to: 40,
                  generator: (j) => Container(
                    width: 100,
                    height: 100,
                    color: (i + j) % 2 == 0 ? Colors.white : Colors.blue,
                  ),
                )),
              ),
            ),
          ),
          buildDecoration: (v, h) {
            return Stack(
              children: [
                Positioned.fill(child: DecoratedScrollable.buildDecorationDefault(v, h)),
                if (v != null) ...[
                  PositionedOnEdgeX.top(_Circle(distance: v.metrics.extentBefore)),
                  PositionedOnEdgeX.bottom(_Circle(distance: v.metrics.extentAfter)),
                ],
                if (h != null) ...[
                  PositionedOnEdgeX.left(_Circle(distance: h.metrics.extentBefore)),
                  PositionedOnEdgeX.right(_Circle(distance: h.metrics.extentAfter)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({Key? key, required this.distance}) : super(key: key);

  final double distance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1, offset: Offset(1, 1))],
          shape: BoxShape.circle,
        ),
        child: AutoSizeText(text: "${distance.round()}"),
      ),
    );
  }
}
