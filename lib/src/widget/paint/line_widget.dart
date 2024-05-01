// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Renders a line consisting of [points] with [width] that is hit testable.
///
/// Internally creates a closed [Path] around the non-closed [Path] defined by [points].
/// See https://github.com/flutter/flutter/issues/96010
class LineWidget extends StatefulWidget {
  const LineWidget({
    Key? key,
    required this.points,
    required this.width,
    required this.color,
    required this.painterSize,
    this.paintKey,
  }) : super(key: key);

  /// The points that make up the line connected from `i` to `i+1`.
  ///
  /// (0,0) is relative to TopLeft of the internal [CustomPainter].
  /// See [painterSize].
  final List<Offset> points;

  /// The color of the line.
  final Color color;

  /// The width of the line.
  final double width;

  /// The size of the [CustomPainter] used to render the line.
  ///
  /// Note that [points] that lie outside this size will be rendered but wont be hit-able.
  /// See [points].
  final Size painterSize;

  /// Key that is passed to the [CustomPainter]
  final GlobalKey? paintKey;

  @override
  State<LineWidget> createState() => _LineWidgetState();
}

class _LineWidgetState extends State<LineWidget> {
  late LinePath linePath = _getPath();
  LinePath _getPath() => LinePath(points: widget.points, width: widget.width);

  late Paint paint = _getPaint();
  Paint _getPaint() => Paint()
    ..color = widget.color
    ..strokeWidth = 1;

  @override
  void didUpdateWidget(covariant LineWidget old) {
    super.didUpdateWidget(old);
    if (!listEquals(old.points, widget.points) || old.width != widget.width) {
      linePath = _getPath();
    }
    if (old.color != widget.color) {
      paint = _getPaint();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: widget.paintKey,
      size: widget.painterSize,
      painter: _LinePathPainter(
        linePath: linePath,
        linePaint: paint,
      ),
    );
  }
}

class _LinePathPainter extends CustomPainter {
  final LinePath linePath;
  final Paint linePaint;

  _LinePathPainter({
    required this.linePath,
    required this.linePaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    linePath.draw(canvas, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LinePathPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) => linePath.hitTest(position);
}

/// A continuous line from [points.first] to [points.last] that is not closed and therefore does not have an internal area.
/// Useful for hit testing lines with some width.
///
/// This is an alternative to using [Path] directly, since non-closed [Path]s can not be hit tested.
/// (Only the exact points `p` on the path are `true == path.contains(p)`)
/// Creates a closed [Path] from [points.first] to [points.last] and back in reverse.
/// Both directions are offset from the direct path by half the [width] in either direction.
class LinePath {
  /// The width of the line.
  /// Determines the hitTest-able area of the line.
  final double width;

  /// Points from start to finish.
  final List<Offset> points;

  late final Path path;

  LinePath({
    this.width = 1.0,
    required List<Offset> points,
  }) : this.points = removeConsecutive(points).toList() {
    if (this.points.length < 2) {
      if (this.points.isEmpty) {
        path = Path();
        return;
      }
      path = Path()
        ..addOval(
          Rect.fromCircle(
            center: this.points.first,
            radius: width / 2,
          ),
        );
      return;
    }

    final List<Path> _linePaths = [];

    // Line segments as rects
    for (int i = 0; i < this.points.length - 1; i++) {
      final p1 = this.points[i];
      final p2 = this.points[i + 1];
      _linePaths.add(_Helper.rectAroundVector(p1, p2, width / 2));
    }
    // for points
    Path _circlePath = Path();
    for (final _p in points) {
      _circlePath.addOval(Rect.fromCircle(center: _p, radius: width / 2));
    }

    // Union over all paths
    for (final _lp in _linePaths) {
      try {
        _circlePath = Path.combine(PathOperation.union, _circlePath, _lp);
      } catch (_) {
        assert(false, "failed to create union");
      }
    }

    path = _circlePath;
  }

  // TODO should paints width be reset?
  void draw(Canvas canvas, Paint paint) {
    canvas.drawPath(path, paint);
  }

  bool hitTest(Offset position) => path.contains(position);
}

class _Helper {
  /// Rotate a vector from [start] to [end] along [start].
  /// Returns rotated vector from [start] to returned value.
  ///
  /// Assumes TopLeft (0,0) and BottomRight (maxX;maxY)
  static Offset rotate90({
    required Offset end,
    bool clockwise = true,
    Offset start = Offset.zero,
  }) {
    final e0 = end - start;
    // (-y, x) is clockwise and (y, -x) is counterclockwise.
    return (clockwise ? Offset(-e0.dy, e0.dx) : Offset(e0.dy, -e0.dx)) + start;
  }

  /// For a vector from [p1] to [p2] returns [p1]s and [p2]s orthogonal points at [distance].
  /// Returns a closed [Path] with `[p1_above, p2_above, p2_below, p1_below]`
  static Path rectAroundVector(Offset p1, Offset p2, double distance) {
    // 1) normalize p2 to p1 as (0,0)
    final p2_zero = p2 - p1;

    // 2) get the orthogonal vector from p1 to above p1 (counter clock to vector)
    final p1_vec_above = rotate90(end: p2_zero, clockwise: false);

    // 4) scale the vectors to the desired distance
    final scale = distance / p1_vec_above.distance;
    final p1_vec_above_scaled = p1_vec_above * scale;

    // 5) get the points above and below p1 and p2
    final p1_above = p1 + p1_vec_above_scaled;
    final p1_below = p1 - p1_vec_above_scaled;
    final p2_above = p2 + p1_vec_above_scaled;
    final p2_below = p2 - p1_vec_above_scaled;

    return Path()
      ..moveTo(p1_above.dx, p1_above.dy)
      ..lineTo(p2_above.dx, p2_above.dy)
      ..lineTo(p2_below.dx, p2_below.dy)
      ..lineTo(p1_below.dx, p1_below.dy)
      ..close();
  }
}

Iterable<T> removeConsecutive<T>(List<T> input) sync* {
  if (input.isEmpty) return;
  T last = input.first;
  yield input.first;
  for (final element in input.skip(1)) {
    if (element == last) {
      continue;
    }
    last = element;
    yield element;
  }
}
