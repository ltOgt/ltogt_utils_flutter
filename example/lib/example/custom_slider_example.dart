import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const CustomSliderExample(),
    );
  }
}

class CustomSliderExample extends StatefulWidget {
  const CustomSliderExample({Key? key}) : super(key: key);

  @override
  State<CustomSliderExample> createState() => _CustomSliderExampleState();
}

class _CustomSliderExampleState extends State<CustomSliderExample> {
  static const SliderConfig sliderConfig = SliderConfig(
    minValue: -100,
    maxValue: 100,
    sliderMainAxisSize: 200,
    sliderCrossAxisSize: 40,
    handleMainAxisSize: 40,
    handleCrossAxisSize: 40,
  );

  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildActionButtons(),
      body: Container(
        color: Colors.grey,
        child: Center(
          child: CustomSlider(
            axisDirection: direction,
            value: value,
            sliderConfig: sliderConfig,
            handle: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1, offset: Offset(1, 1))],
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: AutoSizeText(text: "${value.toInt()}", style: const TextStyle(color: Colors.black)),
            ),
            sliderBefore: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radius,
              ),
            ),
            sliderAfter: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: radius,
              ),
            ),
            onUpdateValue: (value) => setState(() {
              this.value = value;
            }),
          ),
        ),
      ),
    );
  }

  bool roundedCorners = false;
  BorderRadius? get radius => roundedCorners //
      ? BorderRadius.all(Radius.circular(sliderConfig.handleCrossAxisSize))
      : null;

  AxisDirection direction = AxisDirection.right;
  void nextDirection() => setState(() {
        direction = AxisDirection.values[(direction.index + 1) % AxisDirection.values.length];
      });
  IconData get directionIcon {
    switch (direction) {
      case AxisDirection.up:
        return Icons.arrow_upward;
      case AxisDirection.right:
        return Icons.arrow_forward;
      case AxisDirection.down:
        return Icons.arrow_downward;
      case AxisDirection.left:
        return Icons.arrow_back;
    }
  }

  Widget buildActionButtons() {
    return Row(
      children: [
        FloatingActionButton(
          child: Icon(roundedCorners ? Icons.rounded_corner : Icons.select_all),
          onPressed: () => setState(() => roundedCorners = !roundedCorners),
        ),
        FloatingActionButton(
          child: Icon(directionIcon),
          onPressed: nextDirection,
        ),
      ],
    );
  }
}
