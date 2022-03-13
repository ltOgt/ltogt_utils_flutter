import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const AutoSizeTextExample());
}

class AutoSizeTextExample extends StatefulWidget {
  const AutoSizeTextExample({Key? key}) : super(key: key);

  @override
  State<AutoSizeTextExample> createState() => _AutoSizeTextExampleState();
}

class _AutoSizeTextExampleState extends State<AutoSizeTextExample> {
  double height = 100;
  double width = 100;

  void onDrag(DragUpdateDetails details) {
    setState(() {
      height = max(10, height + details.delta.dy);
      width = max(10, width + details.delta.dx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LineWidget example',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: AutoSizeText(
                    text: "This is my auto sized text",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onPanUpdate: onDrag,
                    child: Container(
                      width: 20,
                      height: 20,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
