import 'package:flutter/widgets.dart';

class OverlayManager {
  late OverlayEntry _entry;

  bool isVisible = false;

  OverlayManager(WidgetBuilder builder) {
    _entry = OverlayEntry(
      builder: builder,
    );
  }

  void dispose() {
    hide();
    _entry.dispose();
  }

  void show(BuildContext context) {
    if (isVisible) return;

    final overlay = Overlay.of(context);

    overlay.insert(_entry);
    isVisible = true;
  }

  void hide() {
    if (!isVisible) return;

    _entry.remove();
    isVisible = false;
  }
}
