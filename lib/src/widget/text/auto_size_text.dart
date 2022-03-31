import 'package:flutter/widgets.dart';

class AutoSizeText extends StatelessWidget {
  const AutoSizeText({
    Key? key,
    required this.text,
    this.style,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: alignment,
      fit: BoxFit.contain,
      child: Text(
        text,
        // : only break on actual linebreaks
        softWrap: false,
        overflow: TextOverflow.visible,
        style: style,
      ),
    );
  }
}
