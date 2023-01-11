import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

abstract class TreeNodeAbst {
  final String id;

  const TreeNodeAbst({required this.id});
}

class TreeNode extends TreeNodeAbst {
  const TreeNode({required super.id, required this.builder, required this.children});

  final Widget Function(BuildContext context, TreeBuilderDetails details) builder;
  final List<TreeNodeAbst> children;
}

class TreeLeaf extends TreeNodeAbst {
  const TreeLeaf({required super.id, required this.builder});

  final Widget Function(BuildContext context, TreeBuilderDetails details) builder;
}

class TreeVisibility {
  final Set<String>? collapsed;
  final Set<String>? expanded;
  final bool allCollapsed;
  final bool allExpanded;

  /// does not say whether this id would be visible,
  /// since a parent could be collapsed.
  bool isExpanded(String id) =>
      allExpanded || //
      !allCollapsed && //
          (expanded?.contains(id) ?? !collapsed!.contains(id));

  const TreeVisibility.allCollapsed()
      : this.allCollapsed = true,
        this.allExpanded = false,
        this.collapsed = null,
        this.expanded = null;

  const TreeVisibility.allExpanded()
      : this.allCollapsed = false,
        this.allExpanded = true,
        this.collapsed = null,
        this.expanded = null;

  const TreeVisibility.collapsed(this.collapsed, [this.expanded])
      : this.allCollapsed = false,
        this.allExpanded = false;

  const TreeVisibility.expanded(this.expanded, [this.collapsed])
      : this.allCollapsed = false,
        this.allExpanded = false;

  TreeVisibility expandAll() => TreeVisibility.allExpanded();
  TreeVisibility collapseAll() => TreeVisibility.allCollapsed();
  TreeVisibility expand(String id) => TreeVisibility.expanded(
        CollectionUtils.setAdd(expanded ?? {}, id),
        collapsed == null ? null : CollectionUtils.setRemove(collapsed!, id),
      );
  TreeVisibility collapse(String id) => TreeVisibility.collapsed(
        CollectionUtils.setAdd(collapsed ?? {}, id),
        expanded == null ? null : CollectionUtils.setRemove(expanded!, id),
      );
}

class TreeWidget extends StatelessWidget {
  const TreeWidget({
    super.key,
    required this.treeNodeRoot,
    required this.treeVisibility,
  });

  final TreeNodeAbst treeNodeRoot;
  final TreeVisibility treeVisibility;

  @override
  Widget build(BuildContext context) {
    if (treeNodeRoot is TreeLeaf) {
      return (treeNodeRoot as TreeLeaf).builder(
        context,
        TreeBuilderDetails(
          id: treeNodeRoot.id,
          depth: 0,
          index: 0,
          last: 0,
          isExpanded: false,
        ),
      );
    }
    return _TreeWidget(
      treeNode: treeNodeRoot as TreeNode,
      treeVisibility: treeVisibility,
      index: 0,
      last: 0,
      depth: 0,
    );
  }
}

class _TreeWidget extends StatelessWidget {
  const _TreeWidget({
    required this.treeNode,
    required this.treeVisibility,
    required this.index,
    required this.last,
    required this.depth,
  });

  final TreeNode treeNode;
  final TreeVisibility treeVisibility;
  final int index;
  final int last;
  final int depth;

  @override
  Widget build(BuildContext context) {
    bool isExpanded = treeVisibility.isExpanded(treeNode.id);

    final _treeNode = treeNode.builder(
      context,
      TreeBuilderDetails(
        id: treeNode.id,
        index: index,
        last: last,
        isExpanded: isExpanded,
        depth: depth,
      ),
    );

    return !isExpanded //
        ? _treeNode
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _treeNode,
              ...useValue(
                treeNode.children.length - 1,
                (last) => ListGenerator.forEach(
                  list: treeNode.children,
                  builder: (item, index) => item is TreeLeaf //
                      ? item.builder(
                          context,
                          TreeBuilderDetails(
                            id: item.id,
                            index: index,
                            last: last,
                            isExpanded: false,
                            depth: depth + 1,
                          ),
                        )
                      : _TreeWidget(
                          treeNode: item as TreeNode,
                          treeVisibility: treeVisibility,
                          index: index,
                          last: last,
                          depth: depth + 1,
                        ),
                ),
              )
            ],
          );
  }
}

class TreeBuilderDetails {
  final String id;
  final int depth;
  final int index;
  final int last;
  final bool isExpanded;

  const TreeBuilderDetails({
    required this.id,
    required this.depth,
    required this.index,
    required this.last,
    required this.isExpanded,
  });
}
