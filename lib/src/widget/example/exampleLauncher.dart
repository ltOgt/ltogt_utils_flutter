import 'package:flutter/material.dart';

/// Very basic launcher that creates a list of buttons with names that launch widgets
/// Useful for example apps with multiple examples
class ExampleLauncher extends StatelessWidget {
  const ExampleLauncher({
    Key? key,
    required this.exampleMap,
  }) : super(key: key);

  final Map<String, Widget> exampleMap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final example in exampleMap.entries)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.black,
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Expanded(child: example.value);
                        });
                  },
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: Center(child: Text(example.key)),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
