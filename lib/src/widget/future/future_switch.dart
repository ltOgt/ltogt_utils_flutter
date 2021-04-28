import 'package:flutter/widgets.dart';

/// Depending on the state of the supplied [future], one of three builders is called:
///
/// [buildWait] while the Future is not finished.
/// [buildDone] when the Future completes sucessfully.
/// [buildError] when the Future completes with an error.
class FutureSwitch<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(AsyncSnapshot<T> snap) buildWait;
  final Widget Function(AsyncSnapshot<T> snap) buildDone;
  final Widget Function(AsyncSnapshot<T> snap) buildError;

  const FutureSwitch({
    Key? key,
    required this.future,
    required this.buildWait,
    required this.buildDone,
    required this.buildError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snap) {
        if ([
          ConnectionState.none,
          ConnectionState.waiting,
          ConnectionState.active,
        ].contains(snap.connectionState)) {
          return buildWait(snap);
        } else if (ConnectionState.done == snap.connectionState) {
          if (snap.hasError) {
            return buildError(snap);
          } else if (snap.hasData) {
            return buildDone(snap);
          }
          // no error but also no data
          return buildDone(snap);
        }

        assert(false, "Unexpected State");
        return buildError(snap);
      },
    );
  }
}
