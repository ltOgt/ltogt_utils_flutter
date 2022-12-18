import 'package:flutter/material.dart';

import 'state_component.dart';

class StateComponentText extends StateComponent<TextEditingController> {
  StateComponentText({
    required ComponentState<StatefulWidget> state,
    TextEditingController Function()? onInit,
    void Function(TextEditingController value)? onDispose,
  }) : super(
          onInit: onInit ?? () => TextEditingController(),
          onDispose: onDispose ?? (v) => v.dispose(),
          state: state,
        );
}

class StateComponentScroll extends StateComponent<ScrollController> {
  StateComponentScroll({
    required ComponentState<StatefulWidget> state,
    ScrollController Function()? onInit,
    void Function(ScrollController value)? onDispose,
  }) : super(
          onInit: onInit ?? () => ScrollController(),
          onDispose: onDispose ?? (v) => v.dispose(),
          state: state,
        );
}
