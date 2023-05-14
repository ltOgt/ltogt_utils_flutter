// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class StateComponentSwitch<T, W extends StatefulWidget> extends StateComponent<SwitchController<T>, W> {
  StateComponentSwitch({
    required super.state,
    required SwitchController<T> Function()? onInit,
    void Function(SwitchController<T> value)? onDispose,
    super.onChange,
    super.setStateOnChange,
    super.onDidChangeDependencies,
    super.onDidUpdateWidget,
  }) : super(
          onInit: onInit,
          onDispose: onDispose ?? (v) => v.dispose(),
        );
}

class SwitchOption<T> {
  final T value;
  final Widget child;

  const SwitchOption({
    required this.value,
    required this.child,
  });

  @override
  bool operator ==(covariant SwitchOption<T> other) {
    if (identical(this, other)) return true;

    return other.value == value && other.child == child;
  }

  @override
  int get hashCode => value.hashCode ^ child.hashCode;
}

class SwitchController<T> extends ComponentController {
  String? _label;
  @override
  String? get label => _label;
  set label(String? v) => notify(() => _label = v);

  List<SwitchOption<T>> _options = [];
  List<SwitchOption<T>> get options => _options;
  set options(List<SwitchOption<T>> v) => notify(() => _options = v);

  int _activeIndex;
  int get activeIndex => _activeIndex;
  set activeIndex(int v) => notify(() => _activeIndex = v);

  SwitchOption<T> get value => _options[_activeIndex];

  SwitchController({
    required List<SwitchOption<T>> options,
    required int activeIndex,
    String? label,
  })  : assert(activeIndex >= 0),
        assert(options.isNotEmpty),
        assert(activeIndex < options.length),
        _activeIndex = activeIndex,
        _options = options,
        _label = label;
}
