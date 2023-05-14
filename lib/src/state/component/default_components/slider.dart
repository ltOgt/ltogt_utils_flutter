// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/src/state/component/state_component.dart';

class StateComponentSlider<W extends StatefulWidget> extends StateComponent<SliderController, W> {
  StateComponentSlider({
    required super.state,
    SliderController Function()? onInit,
    void Function(SliderController value)? onDispose,
    super.onChange,
    super.setStateOnChange,
    super.onDidChangeDependencies,
    super.onDidUpdateWidget,
  }) : super(
          onInit: onInit ?? () => SliderController(),
          onDispose: onDispose ?? (v) => v.dispose(),
        );
}

typedef _SliderControllerConvert = double Function(double value);

class SliderController extends ComponentController {
  String? _label;
  @override
  String? get label => _label;
  set label(String? v) => notify(() => _label = v);

  double _value;
  double get value => _value;
  set value(double v) => notify(() => _value = v);

  double _min;
  double get min => _min;
  set min(double v) => notify(() => _min = v);

  double _max;
  double get max => _max;
  set max(double v) => notify(() => _max = v);

  bool _shouldRound;
  bool get shouldRound => _shouldRound;
  set shouldRound(bool v) => notify(() => _shouldRound = v);

  _SliderControllerConvert? _convert;
  _SliderControllerConvert? get convert => _convert;
  set convert(_SliderControllerConvert? f) => notify(() => _convert = f);

  SliderController({
    double value = 0,
    double min = 0,
    double max = 1,
    bool shouldRound = false,
    _SliderControllerConvert? convert,
    String? label,
  })  : _value = value,
        _min = min,
        _max = max,
        _shouldRound = shouldRound,
        _convert = convert,
        _label = label;

  SliderController.roundToMultiple({
    required int of,
    required int currentMultiple,
    required int minMultiple,
    required int maxMultiple,
    String? label,
  })  : _value = (of * currentMultiple).toDouble(),
        _min = (of * minMultiple).toDouble(),
        _max = (of * maxMultiple).toDouble(),
        _shouldRound = true,
        _label = label {
    _convert = (double v) => (v / of).roundToDouble() * of;
  }

  void applyChangedValue(double v) {
    final _v = convert?.call(v) ?? v;
    value = shouldRound ? _v.roundToDouble() : _v;
  }

  @override
  Widget build({
    Color? activeColor,
    Color? inactiveColor,
  }) =>
      Slider(
        value: value,
        onChanged: applyChangedValue,
        max: max,
        min: min,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      );
}
