import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const TextSpanGestureDetectorExample());
}

class TextSpanGestureDetectorExample extends StatefulWidget {
  const TextSpanGestureDetectorExample({Key? key}) : super(key: key);

  @override
  State<TextSpanGestureDetectorExample> createState() => _TextSpanGestureDetectorExampleState();
}

class _TextSpanGestureDetectorExampleState extends ComponentState<TextSpanGestureDetectorExample> {
  late final StateComponentText _ctrlText = StateComponentText(
    state: this,
    onInit: () {
      final c = TextEditingController(
        text:
            "Above is a TextField with limited size, and below is a TextSpanGestureDetector showing the full text. Try (long-)pressing or panning on the text below.",
      );
      c.selection = const TextSelection.collapsed(offset: 0);
      return c;
    },
    setStateOnChange: true,
  );
  late final StateComponentFocus _focus = StateComponentFocus(state: this);

  final double inputHeight = 100;
  final double inputWidth = 500;

  String snackbarText = "";
  void snackbar(String method, TextSpanDetails details) {
    setState(() {
      if (details is TextSpanPanDetails) {
        snackbarText = "$method:\n$details";
      } else {
        snackbarText = "$method:\n$details";
      }
    });
    DelayedUnique.register(
      key: "snackbar",
      wait: const Duration(seconds: 3),
      call: () {
        setState(() {
          snackbarText = "";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          width: double.infinity,
          alignment: Alignment.center,
          child: SizedBox(
            width: inputWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    height: inputHeight,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: const TextSelectionThemeData(
                            selectionColor: Colors.grey,
                            cursorColor: Colors.white,
                          ),
                        ),
                        child: TextField(
                          focusNode: _focus.obj,
                          controller: _ctrlText.obj,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
                          decoration: const InputDecoration.collapsed(
                            hintText: "prompt",
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_ctrlText.obj.text.isNotEmpty)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: TextSpanGestureDetector(
                      onTapUp: (d) {
                        _focus.obj.requestFocus();
                        _ctrlText.obj.selection = d.selection;
                        snackbar("onTapUp", d);
                      },
                      onDoubleTapDown: (d) {
                        // move viewport of text field
                        _focus.obj.requestFocus();
                        _ctrlText.obj.selection = d.selection;
                        setState(() {});

                        // Need to do this on the next frame for some reason,
                        // or the highlight wont show up
                        RenderHelper.addPostFrameCallback((_) {
                          _focus.obj.requestFocus();
                          final index = d.textPosition.offset;

                          final bounds = StringHelper.wordAtIndexBounds(
                            _ctrlText.obj.text,
                            index,
                          );

                          if (bounds == null) {
                            _ctrlText.obj.selection = TextSelection.collapsed(offset: index);
                          } else {
                            _ctrlText.obj.selection = TextSelection(
                              baseOffset: bounds.startIncl,
                              extentOffset: bounds.endExcl,
                            );
                          }

                          snackbar("onDoubleTapDown", d);
                        });
                      },
                      onPanStart: (d) {
                        // move viewport of text field
                        _focus.obj.requestFocus();
                        _ctrlText.obj.selection = d.selection;
                      },
                      onPanUpdate: (d) {
                        _focus.obj.requestFocus();
                        _ctrlText.obj.selection = d.selection;

                        snackbar("onPanUpdate", d);
                      },
                      textSpan: TextSpan(
                        children: [
                          TextSpan(
                            text: _ctrlText.obj.text.substring(
                              0,
                              _ctrlText.obj.selection.start,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          if (_ctrlText.obj.selection.start < _ctrlText.obj.text.length) ...[
                            TextSpan(
                              text: _ctrlText.obj.text.substring(
                                _ctrlText.obj.selection.start,
                                _ctrlText.obj.selection.isCollapsed
                                    ? _ctrlText.obj.selection.start + 1
                                    : _ctrlText.obj.selection.end,
                              ),
                              style: _ctrlText.obj.selection.isCollapsed
                                  ? const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      backgroundColor: Colors.black,
                                    )
                                  : const TextStyle(
                                      backgroundColor: Colors.white,
                                      color: Colors.black,
                                    ),
                            ),
                            if (_ctrlText.obj.selection.end < _ctrlText.obj.text.length)
                              TextSpan(
                                text: _ctrlText.obj.text.substring(
                                  _ctrlText.obj.selection.end + (_ctrlText.obj.selection.isCollapsed ? 1 : 0),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                          ] else
                            const TextSpan(
                              text: "_",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    const SizedBox(height: 200),
                    Text(
                      snackbarText,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
