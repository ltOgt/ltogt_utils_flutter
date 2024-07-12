import 'package:flutter/widgets.dart';

class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    Key? key,
    this.builder,
    this.builderWithEvent,
    this.opaque = false,
    this.onEnter,
    this.onExit,
    this.cursor = MouseCursor.defer,
  })  : assert((builder == null) != (builderWithEvent == null)),
        super(key: key);

  final VoidCallback? onEnter, onExit;
  final Widget Function(bool isHovering)? builder;
  final Widget Function(bool isHovering, PointerEvent? e)? builderWithEvent;
  final bool opaque;
  final MouseCursor cursor;

  @override
  State<HoverBuilder> createState() => HoverBuilderState();
}

class HoverBuilderState extends State<HoverBuilder> {
  bool isHovering = false;
  PointerEvent? _event;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) => setState(() {
        isHovering = true;
        _event = e;
      }),
      onPointerDown: (e) => setState(() {
        isHovering = true;
        _event = e;
      }),
      onPointerMove: (e) => setState(() {
        isHovering = true; // TODO need to check if still is in bounds
        _event = e;
      }),
      child: MouseRegion(
        cursor: widget.cursor,
        opaque: widget.opaque,
        onEnter: (e) => setState(() {
          isHovering = true;
          widget.onEnter?.call();
          _event = e;
        }),
        onHover: widget.builderWithEvent == null
            ? null
            : (e) {
                setState(() {
                  _event = e;
                });
              },
        onExit: (e) => setState(() {
          isHovering = false;
          widget.onExit?.call();
          _event = e;
        }),
        child: widget.builder?.call(isHovering) ?? widget.builderWithEvent?.call(isHovering, _event),
      ),
    );
  }
}
