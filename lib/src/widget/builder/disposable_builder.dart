import 'package:flutter/widgets.dart';

/// Builds with a managed instance of a controller etc
///
/// Does not rebuild on changed parameters, use [key]
class DisposableBuilder<T> extends StatefulWidget {
  const DisposableBuilder({
    super.key,
    required this.init,
    required this.dispose,
    required this.builder,
    this.listen = false,
  });

  final Widget Function(T disposable) builder;
  final T Function() init;
  final void Function(T) dispose;
  final bool listen;

  @override
  State<DisposableBuilder<T>> createState() => _DisposableBuilderState<T>();
}

class _DisposableBuilderState<T> extends State<DisposableBuilder<T>> {
  late T disposable;
  bool listening = false;

  void _rebuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    disposable = widget.init();
    if (widget.listen) {
      if (disposable is! Listenable) {
        assert(false, "Can only listen to Listenables");
      } else {
        (disposable as Listenable).addListener(_rebuild);
        listening = true;
      }
    }
  }

  @override
  void dispose() {
    if (listening) {
      (disposable as Listenable).removeListener(_rebuild);
    }
    widget.dispose(disposable);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(disposable);
  }
}
