import 'package:flutter/widgets.dart';

class ScrollNotificationBuilder extends StatefulWidget {
  const ScrollNotificationBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(ScrollMetrics? metrics) builder;

  @override
  State<ScrollNotificationBuilder> createState() => _ScrollNotificationBuilderState();
}

class _ScrollNotificationBuilderState extends State<ScrollNotificationBuilder> {
  ScrollMetrics? metrics;

  bool _onNotification(Notification? notification) {
    if (!mounted) return false;

    if (notification is ScrollNotification) {
      metrics = notification.metrics;
    } else if (notification is ScrollMetricsNotification) {
      metrics = notification.metrics;
    }

    // Notification might be send during layout, so we sadly need to schedule a post frame callback to setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {});
    });

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      child: widget.builder(metrics),
    );
  }
}
