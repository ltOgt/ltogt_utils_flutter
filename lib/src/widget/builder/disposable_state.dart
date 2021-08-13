import 'package:flutter/widgets.dart';

class DisposableState<T> {
  /// Value of the disposable.
  /// Non-Null after init has been called, and before decode has been called.
  /// E.g. Inside [build] of [DisposableStateBuilder]
  T? value;

  /// Called during init in [DisposableStateBuilder]
  T Function() init;

  /// Add a listener to [T]
  void Function(T)? addListener;

  /// Remove listener from [T].
  /// Must be non-null iff addListener is non-null
  void Function(T)? removeListener;

  // needed because of contravariance
  _addListenerInternal<TI>(TI ti) => addListener?.call(ti as T);
  _removeListenerInternal<TI>(TI ti) => removeListener?.call(ti as T);

  /// Tear down of [T]
  void Function(T) dispose;

  DisposableState({
    required this.init,
    this.addListener,
    this.removeListener,
    required this.dispose,
  }) : assert((removeListener == null) == (addListener == null));
}

class DisposableStateBuilder extends StatefulWidget {
  DisposableStateBuilder({
    Key? key,
    required this.stateMap,
    required this.build,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    Map<dynamic, DisposableState> stateMap,
  ) build;

  /// Add [DisposableState] to be used by the builder.
  ///
  /// The key used to retreive the state again can be anything
  /// - (must support lookup via equals/hash)
  final Map<dynamic, DisposableState> stateMap;

  @override
  _DisposableStateBuilderState createState() => _DisposableStateBuilderState();
}

class _DisposableStateBuilderState extends State<DisposableStateBuilder> {
  @override
  void initState() {
    for (final state in widget.stateMap.values) {
      state.value = state.init();
      state._addListenerInternal(state.value);
    }
    super.initState();
  }

  @override
  void dispose() {
    for (final state in widget.stateMap.values) {
      state._removeListenerInternal(state.value);
      state.dispose(state.value);
      state.value = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, widget.stateMap);
  }
}

class DisposableStateDefaults {
  static DisposableState<T> changeNotifier<T extends ChangeNotifier>({
    required T Function() init,
    void Function(T t)? onChange,
  }) {
    final t = init();
    void _onChange() => onChange!.call(t);

    void _addListener<T>() => t.addListener(_onChange);
    void _removeListener<T>() => t.removeListener(_onChange);

    return DisposableState(
      init: () => t,
      addListener: onChange == null ? null : (_) => _addListener(),
      removeListener: onChange == null ? null : (_) => _removeListener(),
      dispose: (_) => t.dispose(),
    );
  }

  static DisposableState<ScrollController> scrollController({
    void Function(ScrollController ctrl)? onChange,
  }) =>
      DisposableStateDefaults.changeNotifier(init: () => ScrollController(), onChange: onChange);
}
