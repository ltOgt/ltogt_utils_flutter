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
          visibility = details.isExpanded ? visibility.collapse({details.id}) : visibility.expand({details.id});
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

  late final rootNodeDeep = TreeNode(
    id: "root",
    builder: buildNode,
    children: _generateChildren(9),
  );

  List<TreeNodeAbst> _generateChildren(int depth) {
    final count = Random().nextInt(3) + 3;
    return [for (int i = 0; i < count; i++) _generateChild(depth - 1)];
  }

  TreeNodeAbst _generateChild(int depth) {
    if (depth == 0 || Random().nextBool()) {
      return TreeLeaf(id: "${Random().nextInt(999999)}", builder: buildLeaf);
    }
    return TreeNode(id: "${Random().nextInt(999999)}", builder: buildNode, children: _generateChildren(depth - 1));
  }

  String get _visibilityText => """
VISBILITY - ${visibility.mode}

explicit - ${visibility.explicit}
""";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreeWidget example',
      theme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(_visibilityText),
            FloatingActionButton(
              onPressed: () => setState(() {
                visibility = visibility.expandAll();
              }),
              child: const Icon(Icons.fullscreen),
            ),
            FloatingActionButton(
              onPressed: () => setState(() {
                visibility = visibility.collapseAll();
              }),
              child: const Icon(Icons.fullscreen_exit),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TreeWidget(
                treeNodeRoot: rootNodeDeep,
                treeVisibility: visibility,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
