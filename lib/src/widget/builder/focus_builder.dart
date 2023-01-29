import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class FocusBuilder extends StatefulWidget {
  const FocusBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(FocusNode focusNode) builder;

  @override
  State<FocusBuilder> createState() => _FocusBuilderState();
}

class _FocusBuilderState extends ComponentState<FocusBuilder> {
  late StateComponentFocus focus = StateComponentFocus(
    state: this,
    setStateOnChange: true,
  );

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focus.obj,
      child: widget.builder(focus.obj),
    );
  }
}
