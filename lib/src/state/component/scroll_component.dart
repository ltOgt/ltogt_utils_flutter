import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/src/state/component/state_component.dart';

class StateComponentScroll extends StateComponent<ScrollController> {
  StateComponentScroll({
    required ComponentState<StatefulWidget> state,
    ScrollController Function()? onInit,
    void Function(ScrollController value)? onDispose,
  }) : super(
          onInit: onInit ?? () => ScrollController(),
          onDispose: onDispose ??
              (sc) {
                sc.dispose();
              },
          state: state,
        );
}
