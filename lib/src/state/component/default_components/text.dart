// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/src/state/component/state_component.dart';

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
