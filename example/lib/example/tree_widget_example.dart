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

  Color _colorForDepth(int d) => Color.lerp(Colors.black, Colors.white, d / depth)!;
  TextStyle _textForDepth(int d) => TextStyle(
        color: _colorForDepth(d).computeLuminance() > 0.5 ? Colors.black : Colors.white,
      );

  static const _kWidth = 500.0;
  static const _kGap = 20.0;
  static const _kHeight = 20.0;
  Widget _buildNode(BuildContext context, TreeBuilderDetails details, bool isNode) {
    return SizedBox(
      height: _kHeight,
      child: Row(
        children: [
          for (int i = 0; i < details.depth; i++)
            Container(
              width: _kGap,
              height: _kHeight,
              color: _colorForDepth(i),
            ),
          Container(
            height: _kHeight,
            width: _kWidth,
            decoration: BoxDecoration(
              color: _colorForDepth(details.depth),
              borderRadius: details.index == 0
                  ? const BorderRadius.only(topRight: Radius.circular(4.0))
                  : details.index == details.last
                      ? const BorderRadius.only(bottomRight: Radius.circular(4.0))
                      : null,
            ),
            child: Text(
              "${isNode ? "NODE" : "LEAF"}<${details.id}> - ${details.index}...${details.last}${isNode ? details.isExpanded ? "  COLLAPSE" : "  EXPAND" : ""}",
              style: _textForDepth(details.depth),
            ),
          ),
        ],
      ),
    );
  }

  CircleIdGen idGen = CircleIdGen();
  int depth = 5;
  late var rootNode = TreeNode(
    id: "root",
    builder: buildNode,
    children: _generateChildren(depth),
  );

  List<TreeNodeAbst> _generateChildren(int depth, [int? max]) => [
        _generateChild(depth - 1, depth),
        _generateChild(depth - 1, depth),
        _generateChild(depth - 1, depth),
      ];

  TreeNodeAbst _generateChild(int depth, int max) {
    if (depth == 0 || Random().nextDouble() < (1 - depth / max) + .25) {
      return TreeLeaf(id: idGen.next.value, builder: buildLeaf);
    }
    return TreeNode(id: idGen.next.value, builder: buildNode, children: _generateChildren(depth - 1, max));
  }

  String get _visibilityText => """
VISBILITY - ${visibility.mode}

explicit - ${visibility.explicit}
""";

  void rebuildRootNodeDeep(int depth) async {
    setState(() {
      rootNode = TreeNode(
        id: "root",
        builder: buildNode,
        children: _generateChildren(depth),
      );
      this.depth = depth;
    });
  }

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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 400),
                    Text(_visibilityText),
                  ],
                ),
              ),
            ),
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
            FloatingActionButton(
              onPressed: () => rebuildRootNodeDeep(max(1, depth - 1)),
              child: const Icon(Icons.remove),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(20),
              child: Text("$depth", style: const TextStyle(color: Colors.black)),
            ),
            FloatingActionButton(
              onPressed: () => rebuildRootNodeDeep(depth + 1),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        body: TreeWidget.fromRootNode(
          rootNode: rootNode,
          treeVisibility: visibility,
        ),
      ),
    );
  }
}
