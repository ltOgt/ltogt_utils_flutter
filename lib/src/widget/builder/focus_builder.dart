import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class FocusBuilder extends StatefulWidget {
  const FocusBuilder({
    Key? key,
    required this.builder,
    this.focusNode,
  }) : super(key: key);

  final Widget Function(FocusNode focusNode) builder;
  final FocusNode? focusNode;

  @override
  State<FocusBuilder> createState() => _FocusBuilderState();
}

class _FocusBuilderState extends ComponentState<FocusBuilder> {
  late FocusNode focusNode;

  void _update() => setState(() {});

  _init() {
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(_update);
  }

  _dispose(FocusBuilder widget) {
    focusNode.removeListener(_update);
    if (widget.focusNode == null) {
      focusNode.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant FocusBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    _dispose(oldWidget);
    _init();
  }

  @override
  void dispose() {
    _dispose(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: widget.builder(focusNode),
    );
  }
}