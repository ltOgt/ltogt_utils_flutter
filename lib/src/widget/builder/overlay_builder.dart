import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class OverlayBuilder extends StatefulWidget {
  const OverlayBuilder({
    Key? key,
    required this.isVisible,
    required this.overlayBuilder,
    required this.child,
  }) : super(key: key);

  final Widget Function(BuildContext context, Rect? childRectGlobal) overlayBuilder;
  final Widget child;
  final bool isVisible;

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  late OverlayEntry _overlayEntry;

  final GlobalKey _overlayKey = GlobalKey();

  OverlayEntry buildOverlay() {
    final globalRect = RenderHelper.getRect(globalKey: _overlayKey);
    return OverlayEntry(builder: (context) => widget.overlayBuilder(context, globalRect));
  }

  void _showOverlay() {
    _overlayEntry = buildOverlay();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideOverlay() {
    _overlayEntry.remove();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isVisible) {
      RenderHelper.addPostFrameCallback((_) => _showOverlay());
    }
  }

  @override
  void didUpdateWidget(covariant OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isVisible != widget.isVisible) {
      if (oldWidget.isVisible) {
        _hideOverlay();
      } else {
        _showOverlay();
      }
    }
  }

  @override
  void dispose() {
    if (widget.isVisible) {
      _hideOverlay();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
