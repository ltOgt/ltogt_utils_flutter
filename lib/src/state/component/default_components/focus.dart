// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/src/state/component/state_component.dart';

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
