import 'package:example/example/multi_select_text_example.dart';
import 'package:example/example/split_page_to_content_example.dart';
import 'package:example/example/text_span_gesture_detector_example.dart';
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'example/auto_size_text.dart';
import 'example/cached_builder.dart';
import 'example/custom_slider_example.dart';
import 'example/decorated_scrollable.dart';
import 'example/file_tree_example.dart';
import 'example/line_widget.dart';
import 'example/split_resizable_example.dart';
import 'example/state_component.dart';
import 'example/tree_widget_example.dart';

const Map<String, Widget> examplesNameWidget = {
  "LineWidgetExample": LineWidgetExample(),
  "CachedBuilderExample": CachedBuilderExample(),
  "AutoSizeTextExample": AutoSizeTextExample(),
  "FileTreeExample": FileTreeExample(),
  "TreeWidgetExample": TreeWidgetExample(),
  "StateComponentExample": StateComponentExample(),
  "DecoratedScrollable": DecoratedScrollableExample(),
  "SplitResizable": SplitResizableExample(),
  "SplitPageToContentExample": SplitPageToContentExample(),
  "MultiSelectTextExample": MultiSelectTextExample(),
  "TextSpanGestureDetectorExample": TextSpanGestureDetectorExample(),
  "CustomSliderExample": CustomSliderExample(),
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
