import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/src/widget/null_widget.dart';

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
class StateComponent<T, W extends StatefulWidget> {
  final ComponentState<W> state;

  /// The instance of the object [T] wrapped by this component
  ///
  /// E.g. ScrollController
  late T _obj;
  bool _initialized = false;

  /// Returns the wrapped instance of [T]
  @Deprecated("Use obj instead: Confusing with e.g. text controllers: _txt.value.value")
  T get value => obj;

  T get obj {
    /// [init()] will be called by [ComponentState].
    /// It is also legal to only execute after initState via didChangeDependencies
    if (!_initialized) {
      _didChangeDependencies();
    }
    if (!_initialized) {
      throw StateError("value not initialized! call init()");
    }
    return _obj;
  }

  StateComponent({
    required T Function()? onInit,
    required void Function(T obj) onDispose,
    // current will not be initialized if onInit is null
    T Function(T currentIfInitialized)? onDidChangeDependencies,
    T Function(W oldWidget, T current)? onDidUpdateWidget,
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

  final T Function(T currentIfInitialized)? _onDidChangeDependecies;

  final T Function(W oldWidget, T current)? _onDidUpdateWidget;

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
    if (_onInit != null) {
      _obj = _onInit!();
      _initialized = true;
      _listenIfWanted();
    }
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
    if (_initialized && !_listening && shouldListen && _obj is Listenable) {
      (_obj as Listenable).addListener(_onChange);
    }
  }

  void _stopListening() {
    if (_listening) {
      (_obj as Listenable).removeListener(_onChange);
      _listening = false;
    }
  }

  /// Called by [StateComponent]
  void _didChangeDependencies() {
    if (_onDidChangeDependecies != null) {
      /// we cant reference _obj if its not initialized
      /// thats why we compare against null instead
      /// but we still pass _obj to the caller,
      /// who must handle late init errors if no init() was given
      final _c = _initialized ? _obj : null;
      _obj = _onDidChangeDependecies!(_obj);
      _initialized = true;
      if (!identical(_c, _obj)) {
        _stopListening();
        _listenIfWanted();
      }
    }

    assert(_initialized);
  }

  /// Called by [StateComponent]
  void _didUpdateWidget(W oldWidget) {
    assert(_initialized);
    if (_onDidUpdateWidget != null) {
      final _c = obj;
      _obj = _onDidUpdateWidget!(oldWidget, _c);
      if (!identical(_c, _obj)) {
        _stopListening();
        _listenIfWanted();
      }
    }
  }

  /// Called by [StateComponent]
  void _dispose() {
    if (!_initialized) throw StateError("value not initialized! call init()");

    _stopListening();

    _onDispose(_obj);
  }

  @override
  bool operator ==(covariant StateComponent other) {
    return identical(this, other) || other._obj == _obj;
  }

  @override
  int get hashCode => !_initialized ? super.hashCode : _obj.hashCode;
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

abstract class ComponentController extends ChangeNotifier {
  void notify(VoidCallback c) {
    c();
    notifyListeners();
  }

  Widget build() => NullWidget();

  String? get label => null;
}
