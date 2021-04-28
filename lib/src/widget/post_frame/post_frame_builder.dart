import 'package:flutter/widgets.dart';

import 'render_helper.dart';

/// Build a Widget with [childKey] based on its size
class PostFrameBuilder extends StatefulWidget {
  PostFrameBuilder({
    required this.childKey,
    required this.build,
    this.invisibleOnInitialFrame = true,
  });

  final GlobalKey childKey;
  final Widget Function(Size? size, Offset? offset) build;
  final bool invisibleOnInitialFrame;

  @override
  _PostFrameBuilderState createState() => _PostFrameBuilderState();
}

class _PostFrameBuilderState extends State<PostFrameBuilder> {
  Size? size;
  Offset? offset;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Size? size = RenderHelper.getSize(globalKey: widget.childKey);
      Offset? offset = RenderHelper.getPosition(globalKey: widget.childKey);

      if (size != null || offset != null) {
        setState(() {
          this.size = size;
          this.offset = offset;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.build(size, offset);
    if (size != null || offset != null || !widget.invisibleOnInitialFrame) {
      return child;
    }

    if (child is Positioned) {
      /// Iff Child is Positioned it would be streched to match the screen height inside of visible since it does not have the correct stack as its parent.
      /// Thus we replace the child with an identical Positioned and insert the invisibility between it and its child.
      /// After the size has been calculated the actual positioned is returned again (see above)
      ///
      /// To see this for yourself:
      /// 1) return the else branch in any case
      /// 2) set visibile to false
      return Positioned(
        top: child.top,
        left: child.left,
        right: child.right,
        bottom: child.bottom,
        height: child.height,
        width: child.width,
        child: Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainInteractivity: false,
          maintainState: true,
          child: child.child,
        ),
      );
    } else {
      return Visibility(
        visible: false,
        maintainSize: true,
        maintainAnimation: true,
        maintainInteractivity: false,
        maintainState: true,
        child: child,
      );
    }
  }
}
