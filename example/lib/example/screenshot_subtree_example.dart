import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ComponentState<MyApp> {
  final ScreenshotSubtreeTrigger trigger = ScreenshotSubtreeTrigger();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final imgData = await trigger.takeScreenshot();
            final b64 = await imgData.base64Future;
            print(b64);
          },
          child: const Icon(Icons.camera),
        ),
        body: Center(
          child: ScreenshotSubtree(
            child: const Text("Moin Meister"),
            trigger: trigger,
          ),
        ),
      ),
    );
  }
}

/// =============
/// /// =============
/// /// =============
/// /// =============
/// /// =============
