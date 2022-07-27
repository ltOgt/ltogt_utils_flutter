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
  /// The instance of the object [T] wrapped by this component
  ///
  /// E.g. ScrollController
  T? _value;

  /// Returns the wrapped instance of [T]
  T get value {
    /// [init()] will be called by [ComponentState]
    if (_value == null) throw StateError("value not initialized! call init()");
    return _value!;
  }

  StateComponent({
    required T Function()? onInit,
    required void Function(T value) onDispose,
    T? Function(T? value)? onDidChangeDependencies,
    T? Function(Widget oldWidget)? onDidUpdateWidget,
    required ComponentState state,
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
  final void Function(T value) _onDispose;

  final T? Function(T? value)? _onDidChangeDependecies;

  final T? Function(Widget oldWidget)? _onDidUpdateWidget;

  /// Called by [StateComponent]
  ///
  /// It is legal to use [_onDidChangeDependecies] instead.
  /// In that case the first call of [_onDidChangeDependecies] must return a non-null value.
  void _init() {
    _value = _onInit?.call();
  }

  /// Called by [StateComponent]
  void _didChangeDependencies() {
    _value = _onDidChangeDependecies?.call(_value) ?? _value;
    assert(
      _value != null,
      "If _init is not provided, the _value will be null on the first call of _didChangeDependencies\n"
      "In this case, the first call to _onDidChangeDependecies must return a non-null value",
    );
  }

  /// Called by [StateComponent]
  void _didUpdateWidget(Widget oldWidget) {
    _value = _onDidUpdateWidget?.call(oldWidget) ?? _value;
  }

  /// Called by [StateComponent]
  void _dispose() {
    if (_value == null) throw StateError("value not initialiuzed! call init()");
    // ignore: null_check_on_nullable_type_parameter
    _onDispose(_value!);
  }

  @override
  bool operator ==(covariant StateComponent<T> other) {
    if (identical(this, other)) return true;

    return other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;
}

/// Replacement for [State] to be used together with [StatefulWidget].
///
/// Allows the usage of [StateComponent]s.
abstract class ComponentState<T extends StatefulWidget> extends State<T> {
  Set<StateComponent> components = {};

  /// Called by [StateComponent] to self register
  void _componentAdd(StateComponent c) {
    assert(_isBeforeFirstBuild);
    components.add(c);
    c._init();
  }

  /// Used to assert that no components are added after [initState] has been called.
  ///
  /// Only works indirectly by lowering this flag after first build.
  bool _isBeforeFirstBuild = true;

  @override
  @mustCallSuper
  void initState() {
    super.initState();

    /// Need to set to false after first build, since [initState] is called
    /// before [StateComponent]s can self register via [_componentAdd]
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isBeforeFirstBuild = false;
    });
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
