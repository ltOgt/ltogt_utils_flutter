import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Use this if you have a change notifier and want to rebuild on a change.
class ChangeNotifierBuilder<E extends ChangeNotifier> extends StatefulWidget {
  ChangeNotifierBuilder({
    required this.notifier,
    required this.builder,
    this.watch,
    this.onChanged,
  });

  final E notifier;
  final Widget Function(BuildContext context) builder;

  /// Use these methods to extract values from [notifier] that should be checked for potential rebuilds
  /// If this is empty, [builder] is called on every notification from [notifier]
  // TODO evaluate whether this actually does anything positive performancewise
  final List<dynamic Function()>? watch;

  final void Function(E notifier)? onChanged;

  @override
  _ChangeNotifierBuilderState createState() => _ChangeNotifierBuilderState();
}

class _ChangeNotifierBuilderState extends State<ChangeNotifierBuilder> {
  List? rebuildValues;
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(update);
    if (widget.watch != null) {
      rebuildValues = requestRebuildValues();
    }
  }

  List requestRebuildValues() {
    return widget.watch!.map((e) => e.call()).toList();
  }

  void _rebuild(VoidCallback c) {
    setState(c);
    widget.onChanged?.call(widget.notifier);
  }

  update() {
    if (rebuildValues == null) {
      _rebuild(() {});
    } else {
      List _rebuildValues = requestRebuildValues();
      if (false == listEquals(rebuildValues, _rebuildValues)) {
        _rebuild(() {
          rebuildValues = _rebuildValues;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
