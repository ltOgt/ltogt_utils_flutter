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
  int numPerDimension = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decorated Scrollable Example',
      home: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
          ),
          child: CustomSlider(
            value: numPerDimension.toDouble(),
            sliderConfig: const SliderConfig(
              minValue: 0,
              maxValue: 50,
              sliderMainAxisSize: 100,
              sliderCrossAxisSize: 10,
              handleMainAxisSize: 10,
              handleCrossAxisSize: 10,
              axisDirection: AxisDirection.right,
            ),
            handle: Container(color: Colors.white),
            sliderBefore: Container(color: Colors.grey),
            sliderAfter: Container(color: Colors.black),
            onUpdateValue: (value) => setState(() {
              numPerDimension = value.round();
            }),
          ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
          ),
          child: DecoratedScrollable(
            scrollHorizontal: true,
            scrollVertical: true,
            // axis: Axis.vertical,
            // maxAxisSize: 10000,
            child: SizedBox(
              height: 100.0 * numPerDimension,
              width: 100.0 * numPerDimension,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ListGenerator.forRange(
                  to: numPerDimension,
                  generator: (i) => SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ListGenerator.forRange(
                        to: numPerDimension,
                        generator: (j) => Container(
                          width: 100,
                          height: 100,
                          color: (i + j) % 2 == 0 ? Colors.white : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            buildDecoration: (v, h) {
              return Stack(
                children: [
                  Positioned.fill(child: DecoratedScrollable.buildDecorationDefault(v, h)),
                  if (v != null) ...[
                    PositionedOnEdgeX.top(child: _Circle(distance: v.metrics.extentBefore)),
                    PositionedOnEdgeX.bottom(child: _Circle(distance: v.metrics.extentAfter)),
                  ],
                  if (h != null) ...[
                    PositionedOnEdgeX.left(child: _Circle(distance: h.metrics.extentBefore)),
                    PositionedOnEdgeX.right(child: _Circle(distance: h.metrics.extentAfter)),
                  ],
                ],
              );
            },
          ),
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
