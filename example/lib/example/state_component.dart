import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const StateComponentExample());
}

class StateComponentExample extends StatefulWidget {
  const StateComponentExample({super.key});

  @override
  State<StateComponentExample> createState() => _StateComponentExampleState();
}

class _StateComponentExampleState extends State<StateComponentExample> {
  bool includeInTree = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            includeInTree = !includeInTree;
          }),
        ),
        body: includeInTree ? const MyWidget() : null,
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ComponentState<MyWidget> {
  // late final scrollController = StateComponent(
  //   onInit: () => ScrollController(),
  //   onDispose: (s) => s.dispose(),
  //   state: this,
  // );
  //late final scrollController = StateComponentScroll(state: this);
  late final scrollController = StateComponentScroll(
    state: this,
    onInit: () {
      print("initializing");
      return ScrollController();
    },
    onDispose: (value) {
      print("disposing");
      value.dispose();
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => scrollController.value.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceIn,
        ),
      ),
      body: ListView.builder(
        controller: scrollController.value,
        itemCount: 100,
        itemBuilder: (c, i) => Container(
          margin: const EdgeInsets.all(8),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }
}
