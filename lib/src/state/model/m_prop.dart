import 'package:flutter/widgets.dart';

typedef Updater<T> = T Function(T current);

/// A property of a [MPropModel] that holds some [value]
/// and can be [update]d.
///
/// This will call [notifyListeners] of this property,
/// and that of the [parent] - [MPropModel].
/// (Unless called withing [MPropModel.once])
class MProp<T> extends ChangeNotifier {
  T _value;
  T get v => _value;
  T get value => v;
  MProp(T value, this.parent) : _value = value;

  final MPropModel parent;

  void update(Updater<T> updater) {
    final updated = updater(_value);
    if (updated == _value) return;

    _value = updated;

    notifyListeners();
    parent._mPropNotify();
  }
}

/// Pulled out a part of [MPropModel] so that the generic parameter
/// [MPropModel<M>] can be used automatically in [MPropModel.once]
abstract class _AddYourModelAsGeneric extends ChangeNotifier {
  void _mPropNotify() {
    if (!_runsMultiple) {
      return notifyListeners();
    }
    _anyChanged = true;
  }

  bool _runsMultiple = false;
  bool _anyChanged = false;
}

/// A [ChangeNotifier] model in which fields are defined via [MProp]s.
///
/// Consumers can listen to the [MProp] fields and update them,
/// or they can listen to the entire [MPropModel] for any change.
///
/// To update multiple fields with only one [notifyListeners] called for the model,
/// use [MPropModel.once].
///
/// ```dart
/// ///                               vvvvvvvv
/// class _MyModel extends MPropModel<_MyModel> {
///   late final myInt = MProp(0, this);
///   late final myStr = MProp("a", this);
/// }
///
/// void main () {
///   final m = MyModel();
///   m.once((m) {                    // Can be auto typed because of generic
///     m.myInt.update((v) => v + v);
///     m.myStr.update((v) => v + v);
///   });
/// }
/// ```
class MPropModel<M extends _AddYourModelAsGeneric> extends _AddYourModelAsGeneric {
  void once(Function(M m) updates) {
    if (this is! M) {
      assert(false);
      return;
    }
    _runsMultiple = true;
    updates(this as M);
    if (_anyChanged) {
      notifyListeners();
    }
    _runsMultiple = false;
    _anyChanged = false;
  }
}
