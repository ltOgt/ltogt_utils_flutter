import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

/// Caches the result of [builder] and returns the cached [Widget] in [build].
/// Only when [params] change is the cache rebuild.
///
/// This can be used to isolate (large) child trees from their parents rebuilding.
/// Since flutter stops sub-tree rebuilding once the same instance of a widget is encounterd.
class CachedBuilder extends StatefulWidget {
  CachedBuilder({
    Key? key,
    required this.params,
    required this.builder,
  }) : super(key: key);

  final List params;
  final WidgetBuilder builder;

  @override
  State<CachedBuilder> createState() => _CachedBuilderState();
}

class _CachedBuilderState extends State<CachedBuilder> {
  static const _dce = DeepCollectionEquality();

  late Widget _cache;
  _buildCache() => _cache = widget.builder(context);

  @override
  void didUpdateWidget(covariant CachedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_dce.equals(widget.params, oldWidget.params)) {
      _buildCache();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Also called right after initState => no need for initState
    _buildCache();
  }

  @override
  Widget build(BuildContext context) {
    return _cache;
  }
}
