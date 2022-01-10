import 'package:example/example/line_widget.dart';
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'example/disposable_state.dart';

const Map<String, Widget> examplesNameWidget = {
  "DisposableStateExample": DisposableStateExample(),
  "LineWidgetExample": LineWidgetExample(),
};

void main() {
  runApp(
    MaterialApp(
      title: 'example for ltogt_utils_flutter',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(
          child: ExampleLauncher(
            exampleMap: examplesNameWidget,
          ),
        ),
      ),
    ),
  );
}
