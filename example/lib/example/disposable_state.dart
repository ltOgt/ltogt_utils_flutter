import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class DisposableStateExample extends StatelessWidget {
  const DisposableStateExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScrollContent(),
              SizedBox(
                width: 20,
              ),
              ScrollContentWithController(),
            ],
          ),
        ),
      ),
    );
  }
}

class ScrollContent extends StatelessWidget {
  ScrollContent({Key? key}) : super(key: key);

  //var listen;

  @override
  Widget build(BuildContext context) {
    return SmallStateBuilder(
        stateMap: {
          "sc": SmallStateDefaults.scrollController(onChange: (c) => print(c)),
          // "sc": DisposableState<ScrollController>(
          //   init: () => ScrollController(),
          //   addListener: (sc) {
          //     listen = () => print(sc);
          //     sc.addListener(listen);
          //   },
          //   removeListener: (sc) => sc.removeListener(listen),
          //   dispose: (sc) => sc.dispose(),
          // ),
        },
        build: (context, stateMap) {
          return SingleChildScrollView(
            controller: stateMap["sc"]!.value,
            child: Column(
              children: [
                for (int i = 0; i < 100; i++)
                  Container(
                    height: 50,
                    width: 300,
                    color: (i % 2 == 0) ? Colors.black : Colors.blue,
                    child: Text("$i"),
                  ),
              ],
            ),
          );
        });
  }
}

class ScrollContentWithController extends StatefulWidget {
  ScrollContentWithController({Key? key}) : super(key: key);

  @override
  State<ScrollContentWithController> createState() => _ScrollContentWithControllerState();
}

class _ScrollContentWithControllerState extends State<ScrollContentWithController> {
  ScrollController ctrl = ScrollController();
  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmallStateBuilder(
        stateMap: {
          "sc": SmallStateDefaults.scrollController(
            value: ctrl,
            onChange: (c) => print(c),
          ),
        },
        build: (context, stateMap) {
          return SingleChildScrollView(
            controller: stateMap["sc"]!.value,
            child: Column(
              children: [
                for (int i = 0; i < 100; i++)
                  Container(
                    height: 50,
                    width: 300,
                    color: (i % 2 == 0) ? Colors.black : Colors.blue,
                    child: Text("$i"),
                  ),
              ],
            ),
          );
        });
  }
}
