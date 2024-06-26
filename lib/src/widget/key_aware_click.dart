import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef _Builder = Widget Function(BuildContext context, bool canTap);

/// Only enables [onTap] if [logicalKey] is pressed.
class KeyAwareClick extends StatefulWidget {
  const KeyAwareClick({
    required this.logicalKey,
    required this.onTap,
    required Widget this.child,
  })  : builder = null,
        super(key: null);

  const KeyAwareClick.builder({
    required this.logicalKey,
    required this.onTap,
    required _Builder this.builder,
  })  : child = null,
        super(key: null);

  final VoidCallback onTap;
  final LogicalKeyboardKey logicalKey;
  final _Builder? builder;
  final Widget? child;

  @override
  State<KeyAwareClick> createState() => _KeyAwareClickState();
}

class _KeyAwareClickState extends State<KeyAwareClick> {
  bool _keyListenerRegistered = false;
  bool _keyPressed = false;

  // ---------------------------------------------------------------------------

  void _register() {
    if (_keyListenerRegistered) return;
    setState(() {
      _keyListenerRegistered = true;
    });
    HardwareKeyboard.instance.addHandler(handleKeyEvent);

    // initial check on missed events
    if (_keyPressed != HardwareKeyboard.instance.isLogicalKeyPressed(widget.logicalKey)) {
      _keyPressed = !_keyPressed;
    }
  }

  void _unregister() {
    if (!_keyListenerRegistered) return;
    if (mounted) {
      setState(() {
        _keyListenerRegistered = false;
      });
    }
    HardwareKeyboard.instance.removeHandler(handleKeyEvent);
  }

  // ---------------------------------------------------------------------------

  bool handleKeyEvent(KeyEvent e) {
    if (e is KeyDownEvent) {
      if (e.logicalKey == widget.logicalKey) {
        setState(() {
          _keyPressed = true;
        });
        return true;
      }
    }
    if (e is KeyUpEvent) {
      if (e.logicalKey == widget.logicalKey) {
        setState(() {
          _keyPressed = false;
        });
        return true;
      }
    }
    return false;
  }

  // ---------------------------------------------------------------------------

  @override
  void didUpdateWidget(covariant KeyAwareClick oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logicalKey != widget.logicalKey) {
      if (_keyPressed != HardwareKeyboard.instance.isLogicalKeyPressed(widget.logicalKey)) {
        _keyPressed = !_keyPressed;
      }
    }
  }

  @override
  void dispose() {
    if (_keyListenerRegistered) {
      HardwareKeyboard.instance.removeHandler(handleKeyEvent);
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _keyPressed ? SystemMouseCursors.click : MouseCursor.defer,
      // Adding and removing keyboard listener with focus.
      // Speculating that this is better than having many direct keyboard listeners,
      // since hover events are triggered via annotations and hit testing,
      // instead of one big pool of listeners.
      onEnter: (_) => _register(),
      onExit: (_) => _unregister(),
      child: GestureDetector(
        onTap: _keyPressed ? widget.onTap : null,
        child: widget.builder?.call(context, _keyListenerRegistered && _keyPressed) ?? widget.child,
      ),
    );
  }
}
