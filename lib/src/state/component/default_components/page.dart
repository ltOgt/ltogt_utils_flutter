// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/src/state/component/state_component.dart';

class StateComponentPage<W extends StatefulWidget> extends StateComponent<PageController, W> {
  StateComponentPage({
    required super.state,
    PageController Function()? onInit,
    void Function(PageController value)? onDispose,
    super.onChange,
    super.setStateOnChange,
    super.onDidChangeDependencies,
    super.onDidUpdateWidget,
  }) : super(
          onInit: onInit ?? () => PageController(),
          onDispose: onDispose ?? (v) => v.dispose(),
        );
}
