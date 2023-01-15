// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

abstract class TreeNodeAbst {
  final String id;

  const TreeNodeAbst({required this.id});
}

class TreeNode extends TreeNodeAbst {
  TreeNode({
    required super.id,
    required super.builder,
    required this.children,
  }) : assert(children.isNotEmpty);

  final Widget Function(BuildContext context, TreeBuilderDetails details) builder;
  final List<TreeNodeAbst> children;

  @override
  bool operator ==(covariant TreeNode other) {
    if (identical(this, other)) return true;

    return other.builder == builder && listEquals(other.children, children);
  }

  @override
  int get hashCode => builder.hashCode ^ DeepCollectionEquality().hash(children);
}

class TreeLeaf extends TreeNodeAbst {
  const TreeLeaf({required super.id, required this.builder});

  final Widget Function(BuildContext context, TreeBuilderDetails details) builder;

  @override
  bool operator ==(covariant TreeLeaf other) {
    if (identical(this, other)) return true;

    return other.builder == builder;
  }

  @override
  int get hashCode => builder.hashCode;
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

class TreeVisitorData {
  final TreeNode? parent;

  /// the currently visited node
  final TreeNodeAbst node;

  /// current depth of the visited node
  final int depth;

  /// current index in the parents children list
  final int index;

  /// current (parent.length - 1) -> last index in parent
  final int last;

  TreeVisitorData({
    required this.parent,
    required this.node,
    required this.depth,
    required this.index,
    required this.last,
  });

  bool isExpanded(TreeVisibility v) => node is TreeNode && v.isExpanded(node.id);
  bool get isLastChild => index == last;

  @override
  bool operator ==(covariant TreeVisitorData other) {
    if (identical(this, other)) return true;

    return other.parent == parent &&
        other.node == node &&
        other.depth == depth &&
        other.index == index &&
        other.last == last;
  }

  @override
  int get hashCode {
    return parent.hashCode ^ node.hashCode ^ depth.hashCode ^ index.hashCode ^ last.hashCode;
  }
}

abstract class TreeVisitor {
  static TreeVisitorData? _goNextOrUp(TreeVisitorData now, StackList stack) {
    // If not last, go to sibling via parent; no need to pop
    if (now.index < now.last) {
      final nextIndex = now.index + 1;
      return TreeVisitorData(
        parent: now.parent!,
        node: now.parent!.children[nextIndex],
        depth: now.depth,
        index: nextIndex,
        last: now.last,
      );
    }

    // If last, we need to go up until we find a node that is not last
    // then go to its next sibling
    while (true) {
      final _maybeBeforeNext = tryOr(() => stack.pop(), null);
      if (_maybeBeforeNext == null) return null;

      // Need to go further up if also the last
      if (_maybeBeforeNext.isLastChild) continue;

      // Otherwise can go to next
      final _nextIndex = _maybeBeforeNext.index + 1;
      return TreeVisitorData(
        parent: _maybeBeforeNext.parent!,
        node: _maybeBeforeNext.parent!.children[_nextIndex],
        depth: _maybeBeforeNext.depth,
        index: _nextIndex,
        last: _maybeBeforeNext.last,
      );
    }
  }

  // need to build current node before this is called
  static TreeVisitorData? nextVisitor(TreeVisitorData now, StackList stack, TreeVisibility visibility) {
    // for tree nodes we always go down into the first child
    // unless the node is not expanded, then we go next
    if (now.node is TreeNode) {
      // go next or up since children collapsed
      if (!visibility.isExpanded(now.node.id)) {
        return _goNextOrUp(now, stack);
      }

      // go down into first child
      stack.put(now);
      final _cNode = now.node as TreeNode;
      return TreeVisitorData(
        parent: _cNode,
        node: _cNode.children.first,
        depth: now.depth + 1,
        index: 0,
        last: _cNode.children.length - 1,
      );
    }

    // for leafs we go to the next sibling or go up until we can go to the next
    if (now.node is TreeLeaf) {
      // if no parent, we are the root node and done
      if (now.parent == null) return null;

      return _goNextOrUp(now, stack);
    }

    throw "Unknown Type ${now.node.runtimeType}";
  }

  static Iterable<TreeVisitorData> visitInOrder(TreeNodeAbst rootNode, TreeVisibility treeVisibility) sync* {
    StackList<TreeVisitorData> stack = StackList();

    // Current node
    TreeVisitorData c = TreeVisitorData(
      parent: null,
      node: rootNode,
      depth: 0,
      index: 0,
      last: 0,
    );

    while (true) {
      yield c;
      final _newC_orNull = nextVisitor(c, stack, treeVisibility);
      if (_newC_orNull == null) break;
      c = _newC_orNull;
    }
  }
}
