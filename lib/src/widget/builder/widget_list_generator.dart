import 'package:flutter/widgets.dart';
import 'package:ltogt_utils/ltogt_utils.dart';

class WidgetListGenerator {
  static List<Widget> spaced({
    required List<Widget> widgets,
    double? uniform,
    double? width,
    double? height,
    bool beforeFirst = false,
    bool afterLast = false,
  }) {
    assert(uniform == null || (width == null && height == null), "Either specify `uniform` or `width` andor `height`");

    return ListGenerator.seperated(
      list: widgets,
      builder: (Widget w, i) => w,
      seperator: SizedBox(
        width: uniform ?? width,
        height: uniform ?? height,
      ),
    );
  }
}
