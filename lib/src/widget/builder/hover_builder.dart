import 'package:flutter/widgets.dart';

class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    Key? key,
    this.builder,
    this.builderWithEvent,
    this.opaque = false,
  })  : assert((builder == null) != (builderWithEvent == null)),
        super(key: key);

  final Widget Function(bool isHovering)? builder;
  final Widget Function(bool isHovering, PointerEvent? e)? builderWithEvent;
  final bool opaque;

  @override
  State<HoverBuilder> createState() => HoverBuilderState();
}

class HoverBuilderState extends State<HoverBuilder> {
  bool isHovering = false;
  PointerEvent? _event;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: widget.opaque,
      onEnter: (e) => setState(() {
        isHovering = true;
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
        _event = e;
      }),
      child: widget.builder?.call(isHovering) ?? widget.builderWithEvent?.call(isHovering, _event),
    );
  }
}
