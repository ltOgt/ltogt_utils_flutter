import 'package:flutter/widgets.dart';

class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(bool isHovering) builder;

  @override
  State<HoverBuilder> createState() => HoverBuilderState();
}

class HoverBuilderState extends State<HoverBuilder> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() {
        isHovering = true;
      }),
      onExit: (e) => setState(() {
        isHovering = false;
      }),
      child: widget.builder(isHovering),
    );
  }
}
