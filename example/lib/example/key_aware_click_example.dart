import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: const Scaffold(
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KeyAwareClick(
          logicalKey: LogicalKeyboardKey.metaLeft,
          onTap: () => print("Hold Meta-Left and click"),
          child: const Text("Hold Meta-Left and click"),
        ),
        KeyAwareClick(
          logicalKey: LogicalKeyboardKey.keyF,
          onTap: () => print("Hold F and click"),
          child: const Text("Hold F and click"),
        ),
        KeyAwareClick(
          logicalKey: LogicalKeyboardKey.space,
          onTap: () => print("Hold SPACE and click"),
          child: const Text("Hold SPACE and click"),
        ),
      ],
    );
  }
}
