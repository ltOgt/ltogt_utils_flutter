import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const FileTreeExample());
}

class FileTreeExample extends StatelessWidget {
  const FileTreeExample({Key? key}) : super(key: key);

  static const fileTree = FileTree(
    rootDir: FileTreeDir(
      name: "example",
      dirs: [
        FileTreeDir(
          name: "build",
          dirs: [],
        ),
        FileTreeDir(name: "lib", dirs: [
          FileTreeDir(
            name: "example",
            files: [
              FileTreeFile(name: "auto_size_text.dart"),
              FileTreeFile(name: "cached_builder.dart"),
              FileTreeFile(name: "file_tree_example.dart"),
              FileTreeFile(name: "line_widget.dart"),
            ],
          ),
        ], files: [
          FileTreeFile(name: "main.dart"),
        ]),
        FileTreeDir(
          name: "web",
          dirs: [],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileTreeWidget example',
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: FileTreeWidget(
          allExpanded: true,
          fileTree: fileTree,
          onOpenFile: (file) {},
        ),
      ),
    );
  }
}
