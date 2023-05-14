// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/src/state/component/state_component.dart';

class StateComponentScroll<W extends StatefulWidget> extends StateComponent<ScrollController, W> {
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
