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
        ),
      ),
    );
  }
}
