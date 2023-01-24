import 'package:flutter/material.dart';

/// Placeholder for when you need to return a [Widget] but it should never
/// be reached.
class NullWidget extends StatelessWidget {
  const NullWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(false, "NullWidget indicates that it should never be reached.");
    return SizedBox();
  }
}
