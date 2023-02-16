import 'package:flutter/widgets.dart';

extension ScrollMetricsX on ScrollMetrics {
  bool get isBefore => extentBefore > 0;
  bool get isAfter => extentAfter > 0;
  bool get isInsideOnly => !isBefore && !isAfter;
}
