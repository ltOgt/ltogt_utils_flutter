import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const CachedBuilderExample());
}

class CachedBuilderExample extends StatefulWidget {
  const CachedBuilderExample({Key? key}) : super(key: key);

  @override
  State<CachedBuilderExample> createState() => _CachedBuilderExampleState();
}

class _CachedBuilderExampleState extends State<CachedBuilderExample> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cached Builder Example',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () => setState(() {
                  counter += 1;
                }),
              ),
              const SizedBox(
                height: 200,
              ),
              CachedBuilder(
                // : only rebuild every 5 increments
                params: [(counter / 5).floor()],
                builder: (ctx) => GestureDetector(
                  onTap: () => setState(() {
                    counter = 0;
                  }),
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Child(parentCounter: counter),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Child extends StatefulWidget {
  const Child({Key? key, required this.parentCounter}) : super(key: key);

  final int parentCounter;

  @override
  State<Child> createState() => _ChildState();
}

class _ChildState extends State<Child> {
  int childCounter = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        childCounter += 1;
      }),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.red,
        child: Text("${widget.parentCounter} - $childCounter"),
      ),
    );
  }
}
