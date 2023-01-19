import 'package:flutter/material.dart';

import 'state_component.dart';

class StateComponentText extends StateComponent<TextEditingController> {
  StateComponentText({
    required super.state,
    TextEditingController Function()? onInit,
    void Function(TextEditingController value)? onDispose,
    super.onChange,
    super.setStateOnChange,
    super.onDidChangeDependencies,
    super.onDidUpdateWidget,
  }) : super(
          onInit: onInit ?? () => TextEditingController(),
          onDispose: onDispose ?? (v) => v.dispose(),
        );
}

class StateComponentScroll extends StateComponent<ScrollController> {
  StateComponentScroll({
    required super.state,
    ScrollController Function()? onInit,
    void Function(ScrollController value)? onDispose,
    super.onChange,
    super.setStateOnChange,
    super.onDidChangeDependencies,
    super.onDidUpdateWidget,
  }) : super(
          onInit: onInit ?? () => ScrollController(),
          onDispose: onDispose ?? (v) => v.dispose(),
        );
}

class StateComponentFocus extends StateComponent<FocusNode> {
  StateComponentFocus({
    required super.state,
    FocusNode Function()? onInit,
    void Function(FocusNode value)? onDispose,
    super.onChange,
    super.setStateOnChange,
    super.onDidChangeDependencies,
    super.onDidUpdateWidget,
  }) : super(
          onInit: onInit ?? () => FocusNode(),
          onDispose: onDispose ?? (v) => v.dispose(),
        );
}
