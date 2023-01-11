import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  runApp(const TreeWidgetExample());
}

class TreeWidgetExample extends StatefulWidget {
  const TreeWidgetExample({Key? key}) : super(key: key);

  @override
  State<TreeWidgetExample> createState() => _TreeWidgetExampleState();
}

class _TreeWidgetExampleState extends State<TreeWidgetExample> {
  TreeVisibility visibility = const TreeVisibility.allExpanded();

  Widget buildNode(BuildContext context, TreeBuilderDetails details) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() {
          visibility = details.isExpanded ? visibility.collapse(details.id) : visibility.expand(details.id);
          print(visibility);
        }),
        child: _buildNode(context, details, true),
      ),
    );
  }

  Widget buildLeaf(BuildContext context, TreeBuilderDetails details) => _buildNode(
        context,
        details,
        false,
      );

  Color _colorForDepth(int d) => Colors.white.withOpacity(min(1, d / 6 + .1));
  Widget _buildNode(BuildContext context, TreeBuilderDetails details, bool isNode) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          for (int i = 0; i < details.depth; i++)
            Container(
              width: 10,
              height: 20,
              color: _colorForDepth(i),
            ),
          Container(
            height: 20,
            width: 250,
            decoration: BoxDecoration(
              color: _colorForDepth(details.depth),
              borderRadius: details.index == 0
                  ? const BorderRadius.only(topRight: Radius.circular(4.0))
                  : details.index == details.last
                      ? const BorderRadius.only(bottomRight: Radius.circular(4.0))
                      : null,
            ),
            child: Text(
                "${isNode ? "NODE" : "LEAF"}<${details.id}> - ${details.index}...${details.last}${isNode ? details.isExpanded ? "  EXPANDED" : "  COLLAPSED" : ""}"),
          ),
        ],
      ),
    );
  }

  late final rootNode = TreeNode(
    id: "root",
    builder: buildNode,
    children: [
      TreeNode(
        id: "c1",
        builder: buildNode,
        children: [
          TreeLeaf(
            id: "c1l1",
            builder: buildLeaf,
          ),
          TreeLeaf(
            id: "c1l2",
            builder: buildLeaf,
          ),
        ],
      ),
      TreeLeaf(
        id: "l1",
        builder: buildLeaf,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreeWidget example',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TreeWidget(
              treeNodeRoot: rootNode,
              treeVisibility: visibility,
            ),
          ],
        ),
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

  var sorting = FileTreeSorting.none;
  void nextSorting() {
    setState(() {
      switch (sorting) {
        case FileTreeSorting.descending:
          sorting = FileTreeSorting.ascending;
          break;
        case FileTreeSorting.ascending:
          sorting = FileTreeSorting.none;
          break;
        case FileTreeSorting.none:
          sorting = FileTreeSorting.descending;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(onPressed: nextSorting),
      body: FileTreeWidget(
        sorting: sorting,
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
          fileRowStyle: FileTreeEntryStyle(
            colorBg: Colors.white,
            hoverColor: Color(0x55FFFFFF),
            iconColor: Colors.black,
            textStyle: TextStyle(color: Colors.black),
            scopeIndicatorColor: Colors.black,
          ),
          openFileRowStyle: FileTreeEntryStyle(
            colorBg: Colors.grey,
            hoverColor: Color(0x55FFFFFF),
            iconColor: Colors.black,
            textStyle: TextStyle(color: Colors.black),
            scopeIndicatorColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
