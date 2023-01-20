import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const MultiSelectTextExample());
}

class MultiSelectTextExample extends StatefulWidget {
  const MultiSelectTextExample({
    Key? key,
  }) : super(key: key);

  @override
  _MultiSelectTextExampleState createState() => _MultiSelectTextExampleState();
}

class _MultiSelectTextExampleState extends State<MultiSelectTextExample> {
  List<TextRange> selections = [];
  List<bool> selectionActive = [];

  Rect? pressedRect;
  TextPosition? pressedPosition;

  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: MultiSelectText(
                selections: [
                  for (int i = 0; i < selections.length; i++)
                    if (selectionActive[i])
                      MultiSelectTextSelection(
                        textRange: selections[i],
                      ),
                ],
                textSpan: const TextSpan(
                  text:
                      "This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText. This is the example text for you to try out the MultiSelectText.",
                  style: TextStyle(color: Colors.white),
                ),
                onNewSelectionDone: (s) => setState(() {
                  if (s.isCollapsed) return;
                  selections.add(s);
                  selectionActive.add(true);
                }),
                onTapUpSelection: (tp, r) {
                  setState(() {
                    pressedPosition = tp;
                    pressedRect = r;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: 1,
              height: 10, // stretched
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < selections.length; i++)
                      FloatingActionButton.small(
                        child: Text("$i"),
                        backgroundColor: selectionActive[i] ? null : Colors.grey,
                        onPressed: () {
                          setState(() {
                            selectionActive[i] = !selectionActive[i];
                          });
                        },
                      ),
                    const SizedBox(height: 10),
                    Text("Pressed Rect: $pressedRect"),
                    const SizedBox(height: 10),
                    Text("Pressed Position: $pressedPosition"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
