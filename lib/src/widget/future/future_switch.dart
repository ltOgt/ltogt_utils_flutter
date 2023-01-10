import 'package:flutter/material.dart';

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
    required this.buildDone,
    this.buildWait = defaultWait,
    this.buildError = defaultError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return buildWait(snap);
          case ConnectionState.done:
            return snap.hasError //
                ? buildError(snap)
                : buildDone(snap);
        }
      },
    );
  }

  static Widget defaultWait(dynamic _) => const Center(child: CircularProgressIndicator());
  static Widget defaultError(dynamic _) => const Center(child: Icon(Icons.error));
}
