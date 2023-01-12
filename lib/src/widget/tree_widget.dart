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

enum TreeVisibilityMode {
  /// Every ID will be considered collapsed
  allCollapsed,

  /// Every ID will be considered expanded
  allExpanded,

  /// Every ID will be considered collapsed unless in the expanded set
  expanded,

  /// Every ID will be considered expanded unless in the collapsed set
  collapsed,
}

class TreeVisibility {
  final TreeVisibilityMode mode;
  final Set<String>? explicit;

  /// does not say whether this id would be visible,
  /// since a parent could be collapsed.
  bool isExpanded(String id) {
    switch (mode) {
      case TreeVisibilityMode.allCollapsed:
        return false;
      case TreeVisibilityMode.allExpanded:
        return true;
      case TreeVisibilityMode.expanded:
        return explicit!.contains(id);
      case TreeVisibilityMode.collapsed:
        return !explicit!.contains(id);
    }
  }

  const TreeVisibility.allCollapsed()
      : this.mode = TreeVisibilityMode.allCollapsed,
        this.explicit = null;

  const TreeVisibility.allExpanded()
      : this.mode = TreeVisibilityMode.allExpanded,
        this.explicit = null;

  const TreeVisibility.collapsed(this.explicit) : this.mode = TreeVisibilityMode.collapsed;

  const TreeVisibility.expanded(this.explicit) : this.mode = TreeVisibilityMode.expanded;

  const TreeVisibility._({
    required this.mode,
    required this.explicit,
  });

  TreeVisibility expandAll() => TreeVisibility.allExpanded();
  TreeVisibility collapseAll() => TreeVisibility.allCollapsed();
  TreeVisibility expand(Set<String> ids) {
    switch (mode) {
      case TreeVisibilityMode.allCollapsed:
        return TreeVisibility.expanded({...ids});
      case TreeVisibilityMode.allExpanded:
        return TreeVisibility.allExpanded();
      case TreeVisibilityMode.expanded:
        return TreeVisibility._(mode: mode, explicit: {...explicit!, ...ids});
      case TreeVisibilityMode.collapsed:
        return TreeVisibility._(mode: mode, explicit: {
          for (final e in explicit!)
            if (!ids.contains(e)) e
        });
    }
  }

  TreeVisibility collapse(Set<String> ids) {
    switch (mode) {
      case TreeVisibilityMode.allCollapsed:
        return TreeVisibility.allCollapsed();
      case TreeVisibilityMode.allExpanded:
        return TreeVisibility.collapsed(ids);
      case TreeVisibilityMode.expanded:
        return TreeVisibility._(mode: mode, explicit: {
          for (final e in explicit!)
            if (!ids.contains(e)) e
        });
      case TreeVisibilityMode.collapsed:
        return TreeVisibility._(mode: mode, explicit: {...explicit!, ...ids});
    }
  }
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
