import 'package:example/example/auto_size_text.dart';
import 'package:example/example/cached_builder.dart';
import 'package:example/example/file_tree_example.dart';
import 'package:example/example/line_widget.dart';
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'example/disposable_state.dart';

const Map<String, Widget> examplesNameWidget = {
  "DisposableStateExample": DisposableStateExample(),
  "LineWidgetExample": LineWidgetExample(),
  "CachedBuilderExample": CachedBuilderExample(),
  "AutoSizeTextExample": AutoSizeTextExample(),
  "FileTreeExample": FileTreeExample(),
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
