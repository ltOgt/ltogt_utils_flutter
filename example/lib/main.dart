import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

import 'example/disposable_state.dart';

const List<List> examples_name_widget = [
  ["DisposableStateExample", DisposableStateExample()],
];

void main() {
  runApp(
    MaterialApp(
      title: 'example for ltogt_utils_flutter',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: examples_name_widget
                  .map(
                    (List item) => Material(
                      color: Colors.black,
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => item[1],
                          ),
                        ),
                        child: SizedBox(
                          width: 300,
                          height: 50,
                          child: Center(child: Text(item[0])),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }),
      ),
    ),
  );
}
