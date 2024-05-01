import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const LineWidgetExample());
}

class LineWidgetExample extends StatefulWidget {
  const LineWidgetExample({Key? key}) : super(key: key);

  @override
  State<LineWidgetExample> createState() => _LineWidgetExampleState();
}

class _LineWidgetExampleState extends State<LineWidgetExample> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LineWidget example',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Click the path",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    clicked = !clicked;
                  }),
                  child: LineWidget(
                    points: const [
                      Offset(90, 10),
                      Offset(10, 10),
                      Offset(10, 90),
                      Offset(90, 90),
                      Offset(90, 45),
                      Offset(45, 45),
                    ],
                    width: 8,
                    color: clicked ? Colors.red : Colors.white,
                    painterSize: const Size(100, 100),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Edge Cases",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Empty List",
                  style: TextStyle(color: Colors.white),
                ),
                LineWidget(
                  points: const [],
                  width: 8,
                  color: clicked ? Colors.red : Colors.white,
                  painterSize: const Size(100, 100),
                ),
                const Text(
                  "2 Same Points",
                  style: TextStyle(color: Colors.white),
                ),
                LineWidget(
                  points: const [
                    Offset(10, 10),
                    Offset(10, 10),
                  ],
                  width: 8,
                  color: clicked ? Colors.red : Colors.white,
                  painterSize: const Size(100, 100),
                ),
                const Text(
                  "2x2 Same Points",
                  style: TextStyle(color: Colors.white),
                ),
                LineWidget(
                  points: const [
                    Offset(0, 0),
                    Offset(0, 0),
                    Offset(10, 10),
                    Offset(10, 10),
                  ],
                  width: 8,
                  color: clicked ? Colors.red : Colors.white,
                  painterSize: const Size(100, 100),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
