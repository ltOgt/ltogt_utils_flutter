import 'package:flutter/widgets.dart';

/// Wrapper for any object that needs to be initialized or disposed along with the state.
///
/// To be used within [ComponentState] as replacement for [State].
///
/// Allows to
/// + group object init and dispose at one place (instead of in state methods)
/// + reuse custom initialization and disposing logic by extending this class
///
/// ```dart
///
/// class _MyWidgetState extends ComponentState<MyWidget> {
///   late final scrollController = StateComponent(
///     onInit: () => ScrollController(),
///     onDispose: (s) => s.dispose(),
///     state: this,
///   );
///
///   // No need for [initState] and [dispose]
///
///   build(c) => ...;
/// }
/// ```
class StateComponent<T> {
  final ComponentState state;

  /// The instance of the object [T] wrapped by this component
  ///
  /// E.g. ScrollController
  T? _obj;

  /// Returns the wrapped instance of [T]
  @Deprecated("Use obj instead: Confusing with e.g. text controllers: _txt.value.value")
  T get value => obj;

  T get obj {
    /// [init()] will be called by [ComponentState].
    /// It is also legal to only execute after initState via didChangeDependencies
    if (_obj == null) {
      _didChangeDependencies();
    }
    if (_obj == null) {
      throw StateError("value not initialized! call init()");
    }
    return _obj!;
  }

  StateComponent({
    required T Function()? onInit,
    required void Function(T obj) onDispose,
    T? Function(T? obj)? onDidChangeDependencies,
    T? Function(Widget oldWidget)? onDidUpdateWidget,
    required this.state,
    this.setStateOnChange = false,
    this.onChange,
  })  : _onInit = onInit,
        _onDispose = onDispose,
        _onDidChangeDependecies = onDidChangeDependencies,
        _onDidUpdateWidget = onDidUpdateWidget,
        assert(onInit != null || onDidChangeDependencies != null) {
    state._componentAdd(this);
  }

  /// Callback to initialize [T]
  final T Function()? _onInit;

  /// Callback to dispose [T]
  final void Function(T obj) _onDispose;

  final T? Function(T? obj)? _onDidChangeDependecies;

  final T? Function(Widget oldWidget)? _onDidUpdateWidget;

  /// Requires [T] is [Listenable].
  /// Adds listener that calls [state.setState].
  ///
  /// Also see [onChange], for additional side effects.
  final bool setStateOnChange;

  /// Requires [T] is [Listenable].
  /// Adds [onChange] callback.
  ///
  /// Also see [setStateOnChange], which can be combined.
  final Function()? onChange;

  /// Called by [StateComponent]
  ///
  /// It is legal to use [_onDidChangeDependecies] instead.
  /// In that case the first call of [_onDidChangeDependecies] must return a non-null value.
  void _init() {
    _obj = _onInit?.call();
    _listenIfWanted();
  }

  void _onChange() {
    if (setStateOnChange) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
    }
    onChange?.call();
  }

  bool get shouldListen => setStateOnChange || onChange != null;
  bool _listening = false;
  void _listenIfWanted() {
    if (!_listening && shouldListen && _obj != null && _obj is Listenable) {
      (_obj as Listenable).addListener(_onChange);
    }
  }

  /// Called by [StateComponent]
  void _didChangeDependencies() {
    _obj = _onDidChangeDependecies?.call(_obj) ?? _obj;
    _listenIfWanted();
    assert(
      _obj != null,
      "If _init is not provided, the _value will be null on the first call of _didChangeDependencies\n"
      "In this case, the first call to _onDidChangeDependecies must return a non-null value",
    );
  }

  /// Called by [StateComponent]
  void _didUpdateWidget(Widget oldWidget) {
    _obj = _onDidUpdateWidget?.call(oldWidget) ?? _obj;
  }

  /// Called by [StateComponent]
  void _dispose() {
    if (_obj == null) throw StateError("value not initialiuzed! call init()");

    if (_listening) {
      (_obj as Listenable).removeListener(_onChange);
      _listening = false;
    }

    // ignore: null_check_on_nullable_type_parameter
    _onDispose(_obj!);
  }

  @override
  bool operator ==(covariant StateComponent other) {
    if (identical(this, other)) return true;

    return other._obj == _obj;
  }

  @override
  int get hashCode => _obj.hashCode;
}

/// Replacement for [State] to be used together with [StatefulWidget].
///
/// Allows the usage of [StateComponent]s.
abstract class ComponentState<T extends StatefulWidget> extends State<T> {
  Set<StateComponent> components = {};

  /// Called by [StateComponent] to self register
  void _componentAdd(StateComponent c) {
    components.add(c);
    c._init();
  }

  @override
  void didChangeDependencies() {
    for (var e in components) {
      e._didChangeDependencies();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    for (var e in components) {
      e._didUpdateWidget(oldWidget);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  @mustCallSuper
  void dispose() {
    /// Dispose all registered components
    for (var e in components) {
      e._dispose();
    }
    super.dispose();
  }
}
