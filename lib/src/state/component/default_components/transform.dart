// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/src/state/component/state_component.dart';

class StateComponentTransform<W extends StatefulWidget> extends StateComponent<TransformationController, W> {
  StateComponentTransform({
    required super.state,
    TransformationController Function()? onInit,
    void Function(TransformationController value)? onDispose,
    super.onChange,
    super.setStateOnChange,
    super.onDidChangeDependencies,
    super.onDidUpdateWidget,
  }) : super(
          onInit: onInit ?? () => TransformationController(),
          onDispose: onDispose ?? (v) => v.dispose(),
        );
}
