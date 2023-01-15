// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

// ============================================================================= Nested Tree Data
abstract class TreeNodeAbst {
  final String id;
  final Widget Function(BuildContext context, TreeBuilderDetails details) builder;

  const TreeNodeAbst({required this.id, required this.builder});
}

class TreeNode extends TreeNodeAbst {
  TreeNode({
    required super.id,
    required super.builder,
    required this.children,
  }) : assert(children.isNotEmpty);

  final List<TreeNodeAbst> children;

  @override
  bool operator ==(covariant TreeNode other) {
    if (identical(this, other)) return true;

    return other.builder == builder && listEquals(other.children, children);
  }

  @override
  int get hashCode => builder.hashCode ^ DeepCollectionEquality().hash(children);

  @override
  String toString() => 'TreeNode(id: $id, children: $children)';
}

class TreeLeaf extends TreeNodeAbst {
  const TreeLeaf({required super.id, required super.builder});

  @override
  bool operator ==(covariant TreeLeaf other) {
    if (identical(this, other)) return true;

    return other.builder == builder;
  }

  @override
  int get hashCode => builder.hashCode;
  @override
  String toString() => 'TreeNode(id: $id)';
}

// ============================================================================= Tree Visibility

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

// ============================================================================= Tree Widget

class TreeWidget extends StatelessWidget {
  TreeWidget({
    super.key,
    required this.treeNodeRoot,
    required this.treeVisibility,
  }) {
    this._children = [];

    for (final v in TreeVisitor.visible(treeNodeRoot, treeVisibility)) //
    {
      print(v);
      _children.add(v);
    }
  }

  final TreeNodeAbst treeNodeRoot;
  final TreeVisibility treeVisibility;
  late final List<TreeVisitorData> _children;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (final c in _children) //
        c.node.builder(
          context,
          TreeBuilderDetails(
            id: c.node.id,
            depth: c.depth,
            index: c.index,
            last: c.last,
            isExpanded: c.isExpanded(treeVisibility),
          ),
        )
    ]);
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

// ============================================================================= Visitor

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

  /// Skip data only available when constructed via [TreeVisitor.flatten]
  /// Basically nullable late initialization.
  int? _skip;

  @visibleForTesting
  set skip(int? v) {
    // must be nullable since types of set and get must match
    if (v == null) throw StateError("Dont set skip to null manually");
    if (_skip != null) throw StateError("Skip already set");
    _skip = v;
  }

  /// How many ancestors this node has in total (incl. childrens children etc)
  /// Only available when constructed via [TreeVisitor.flatten]
  /// Otherwise always `null`, see [isFlattened]
  int? get skip => _skip;
  bool get isFlattened => _skip != null;

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

  @override
  String toString() {
    return 'TreeVisitorData(p=$parent,n=$node,d=$depth,i=$index,l=$last)';
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
  static TreeVisitorData? _nextVisitor(TreeVisitorData now, StackList stack, TreeVisibility visibility) {
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

  /// Takes the nested tree starting at [rootNode] and returns an ordered list of
  /// all visible nodes ([treeVisibility]) described via [TreeVisitorData].
  static Iterable<TreeVisitorData> visible(TreeNodeAbst rootNode, TreeVisibility treeVisibility) sync* {
    StackList<TreeVisitorData> stack = StackList();

    TreeVisitorData currentNode = TreeVisitorData(
      parent: null,
      node: rootNode,
      depth: 0,
      index: 0,
      last: 0,
    );

    while (true) {
      yield currentNode;
      final _nextOrNull = _nextVisitor(currentNode, stack, treeVisibility);
      if (_nextOrNull == null) break;
      currentNode = _nextOrNull;
    }
  }

  /// Takes the nested tree starting at [rootNode] and returns an ordered list of
  /// all nodes described via [TreeVisitorData].
  /// Also counts the descendants for each entry into [TreeVisitorData.skip].
  static List<TreeVisitorData> flatten(TreeNodeAbst rootNode) {
    final expanded = visible(rootNode, TreeVisibility.allExpanded()).toList();
    final length = expanded.length;

    int fallback = length + 1;
    int maxDepth = 0;
    Map<int, int> previousIndexForDepth = {};

    for (int i = length; i > 0; i--) {
      final data = expanded[i - 1];
      final node = data.node;
      if (node is TreeLeaf) {
        data.skip = 0;
      } else {
        assert(node is TreeNode);
        final depth = data.depth;

        if (depth > maxDepth) {
          final previousForOldMaxDepth = previousIndexForDepth[maxDepth] ?? fallback;
          for (final d in Range(depth, min: maxDepth)) {
            previousIndexForDepth[d] = previousForOldMaxDepth;
          }

          maxDepth = depth;
        }

        final previous = previousIndexForDepth[depth] ?? fallback;
        final newForDepth = previous - i - 1;
        for (final d in Range(maxDepth, min: depth)) {
          previousIndexForDepth[d] = newForDepth;
        }

        data.skip = newForDepth;
      }
    }
    return expanded;
  }
}
