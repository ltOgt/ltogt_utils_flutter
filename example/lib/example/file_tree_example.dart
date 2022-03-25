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
    return const MaterialApp(
      title: 'FileTreeWidget example',
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: TreeStateWidget(fileTree: fileTree),
      ),
    );
  }
}

class TreeStateWidget extends StatefulWidget {
  const TreeStateWidget({
    Key? key,
    required this.fileTree,
  }) : super(key: key);

  final FileTree fileTree;

  @override
  State<TreeStateWidget> createState() => _TreeStateWidgetState();
}

class _TreeStateWidgetState extends State<TreeStateWidget> {
  Set<FileTreePath> expandedDirs = {};
  Set<FileTreePath> openFiles = {};

  @override
  Widget build(BuildContext context) {
    return FileTreeWidget(
      expandedDirectories: expandedDirs,
      onToggleDirExpansion: (path, expanded) {
        if (expanded) {
          expandedDirs.add(path);
        } else {
          expandedDirs.remove(path);
        }
        setState(() {});
      },
      fileTree: widget.fileTree,
      openFiles: openFiles,
      onOpenFile: (file) {
        if (openFiles.contains(file)) {
          openFiles.remove(file);
        } else {
          openFiles.add(file);
        }
        setState(() {});
      },
      style: const FileTreeWidgetStyle(
        openFileRowStyle: FileTreeEntryStyle(
          colorBg: Colors.black,
          hoverColor: Color(0x55FFFFFF),
          iconColor: Colors.white,
          textStyle: TextStyle(color: Colors.white),
          scopeIndicatorColor: Colors.white,
        ),
      ),
    );
  }
}
