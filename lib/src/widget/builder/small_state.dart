import 'package:flutter/widgets.dart';

class SmallState<T> {
  /// Value of the disposable.
  ///
  /// If [value] is provided (non-null) in constructor, [init] and [dispose] are never called.
  ///
  /// If [value] is not provided (null) in constructor, [init] and [dispose] are called to create and tear down object.
  /// Non-Null after init has been called, and before decode has been called.
  /// E.g. Inside [build] of [SmallStateBuilder]
  T? value;

  /// Called during init in [SmallStateBuilder] iff [value] is not provided.
  ///
  /// Required iff [value] is null.
  T Function()? init;

  /// Add a listener to [T]
  void Function(T)? addListener;

  /// Remove listener from [T].
  /// Must be non-null iff addListener is non-null
  void Function(T)? removeListener;

  // needed because of contravariance
  _addListenerInternal<TI>(TI ti) => addListener?.call(ti as T);
  _removeListenerInternal<TI>(TI ti) => removeListener?.call(ti as T);

  /// Tear down of [T] created with [init] iff [value] is not provided.
  ///
  /// Required iff [value] is null.
  void Function(T)? dispose;

  factory SmallState.value({
    required T value,
    Function(T)? addListener,
    Function(T)? removeListener,
  }) =>
      SmallState(
        value: value,
        init: null,
        dispose: null,
        addListener: addListener,
        removeListener: removeListener,
      );

  factory SmallState.create({
    required T Function() init,
    required Function(T) dispose,
    Function(T)? addListener,
    Function(T)? removeListener,
  }) =>
      SmallState(
        value: null,
        init: init,
        dispose: dispose,
        addListener: addListener,
        removeListener: removeListener,
      );

  SmallState({
    required this.value,
    required this.init,
    this.addListener,
    this.removeListener,
    required this.dispose,
  })  : assert((removeListener == null) == (addListener == null), "Must removeListener iff addListener"),
        assert((value == null) != (init == null && dispose == null), "Must pass value XOR init & dispose");
}

class SmallStateBuilder extends StatefulWidget {
  SmallStateBuilder({
    Key? key,
    required this.stateMap,
    required this.build,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    Map<dynamic, SmallState> stateMap,
  ) build;

  /// Add [SmallState] to be used by the builder.
  ///
  /// The key used to retreive the state again can be anything
  /// - (must support lookup via equals/hash)
  final Map<dynamic, SmallState> stateMap;

  @override
  _SmallStateBuilderState createState() => _SmallStateBuilderState();
}

class _SmallStateBuilderState extends State<SmallStateBuilder> {
  @override
  void initState() {
    for (final state in widget.stateMap.values) {
      if (state.init != null) {
        state.value = state.init!();
      }
      state._addListenerInternal(state.value);
    }
    super.initState();
  }

  @override
  void dispose() {
    for (final state in widget.stateMap.values) {
      state._removeListenerInternal(state.value);
      if (state.dispose != null) {
        state.dispose!(state.value);
      }

      state.value = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, widget.stateMap);
  }
}

class SmallStateDefaults {
  /// Use [value] or create new [T] to be used via [SmallStateBuilder].
  /// Optionally add a listener.
  static SmallState<T> changeNotifier<T extends ChangeNotifier>({
    T Function()? init,
    T? value,
    void Function(T t)? onChange,
  }) {
    assert((init == null) != (value == null), "Provide either init or value");

    bool useValue = value != null;

    final _t = useValue ? value : init!();
    final _init = useValue ? null : () => _t;
    final _disp = useValue ? null : (T _) => _t.dispose();

    void _onChange() => onChange!.call(_t);

    void _addListener<T>() => _t.addListener(_onChange);
    void _removeListener<T>() => _t.removeListener(_onChange);

    return SmallState(
      value: useValue ? value : null,
      init: _init,
      addListener: onChange == null ? null : (_) => _addListener(),
      removeListener: onChange == null ? null : (_) => _removeListener(),
      dispose: _disp,
    );
  }

  /// Use [value] or create new [ScrollController] to be used via [SmallStateBuilder].
  /// Optionally add a listener.
  static SmallState<ScrollController> scrollController({
    void Function(ScrollController ctrl)? onChange,
    ScrollController? value,
  }) =>
      SmallStateDefaults.changeNotifier(
        value: value,
        init: value != null ? null : () => ScrollController(),
        onChange: onChange,
      );
}
