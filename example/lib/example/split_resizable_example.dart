import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const SplitResizableExample());
}

class SplitResizableExample extends StatefulWidget {
  const SplitResizableExample({Key? key}) : super(key: key);

  @override
  State<SplitResizableExample> createState() => _SplitResizableExampleState();
}

class _SplitResizableExampleState extends State<SplitResizableExample> {
  double splitFraction = .3;

  var axis = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SplitResizable(
          childA: Container(color: Colors.blue),
          childB: Container(color: Colors.red),
          axis: axis,
          fractionA: splitFraction,
          onFractionChanged: (value) => setState(() {
            splitFraction = value;
          }),
          seperator: Container(color: Colors.black),
          seperatorWidth: 3,
        ),
      ),
    );
  }
}
