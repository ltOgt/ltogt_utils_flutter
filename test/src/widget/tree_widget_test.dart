// import 'package:flutter_test/flutter_test.dart';
// import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

// TreeVisibility get allCollapsed => TreeVisibility.allCollapsed();
// TreeVisibility get allExpanded => TreeVisibility.allExpanded();
// TreeVisibility get collapsed => TreeVisibility.collapsed({"1", "2"});
// TreeVisibility get expanded => TreeVisibility.expanded({"1", "2"});

// void main() {
//   group('TreeVisibility', () {
//     group("create via", () {
//       test('allCollapsed', () async {
//         final actual = TreeVisibility.allCollapsed();
//         expect(actual.allCollapsed, isTrue);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, isNull);
//       });
//       test('allExpanded', () async {
//         final actual = TreeVisibility.allExpanded();
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isTrue);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, isNull);
//       });
//       test('collapsed', () async {
//         final actual = TreeVisibility.collapsed({"1", "2"});
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, {"1", "2"});
//         expect(actual.expanded, isNull);
//       });
//       test('expanded', () async {
//         final actual = TreeVisibility.expanded({"1", "2"});
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, {"1", "2"});
//       });
//     });

//     group("transition via", () {
//       test("collapse - in set", () {
//         var actual;
//         actual = allCollapsed.collapse("2");
//         expect(actual.allCollapsed, isTrue);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, isNull);

//         actual = allExpanded.collapse("2");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, {"2"});
//         expect(actual.expanded, isNull);

//         actual = collapsed.collapse("2");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, {"1", "2"});
//         expect(actual.expanded, isNull);

//         actual = expanded.collapse("2");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, {"2"});
//         expect(actual.expanded, {"1"});
//       });

//       test("collapse - out set", () {
//         var actual;
//         actual = allCollapsed.collapse("3");
//         expect(actual.allCollapsed, isTrue);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, isNull);

//         actual = allExpanded.collapse("3");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, {"3"});
//         expect(actual.expanded, isNull);

//         actual = collapsed.collapse("3");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, {"1", "2", "3"});
//         expect(actual.expanded, isNull);

//         actual = expanded.collapse("3");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, {"1", "2"});
//       });

//       test("expand - in set", () {
//         var actual;
//         actual = allCollapsed.expand("2");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, {"2"});

//         actual = allExpanded.expand("2");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isTrue);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, isNull);

//         actual = collapsed.expand("2");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, {"1", "2"});
//         expect(actual.expanded, isNull);

//         actual = expanded.expand("2");
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, {"1", "2"});
//       });

//       test("TEMPLATE", () {
//         var actual;
//         actual = allCollapsed;
//         expect(actual.allCollapsed, isTrue);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, isNull);

//         actual = allExpanded;
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isTrue);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, isNull);

//         actual = collapsed;
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, {"1", "2"});
//         expect(actual.expanded, isNull);

//         actual = expanded;
//         expect(actual.allCollapsed, isFalse);
//         expect(actual.allExpanded, isFalse);
//         expect(actual.collapsed, isNull);
//         expect(actual.expanded, {"1", "2"});
//       });
//     });
//   });
// }

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

void main() {
  group('TreeVisitor', () {
    group('visible', () {
      test('leaf only => returns only it self', () async {
        final tree = TreeLeaf(id: "lr", builder: (_, __) => SizedBox());
        final visibilityMock = TreeVisibilityNeverCalled.any();
        final asList = [
          for (final visitor in TreeVisitor.visible(tree, visibilityMock)) //
            visitor,
        ];

        expect(asList, [TreeVisitorData(parent: null, node: tree, depth: 0, index: 0, last: 0)]);
        expect(visibilityMock.neverCalled, isTrue);
      });

      group("deep tree", () {
        final builder = (context, details) => SizedBox();
        final b = TreeLeaf(id: "b", builder: builder);
        final a2a = TreeLeaf(id: "a2a", builder: builder);
        final a2 = TreeNode(id: "a2", builder: builder, children: [a2a]);
        final a1 = TreeLeaf(id: "a1", builder: builder);
        final a = TreeNode(id: "a", builder: builder, children: [a1, a2]);
        final tree = TreeNode(id: "r", builder: builder, children: [a, b]);

        test('complex node + all collapsed => returns only root', () async {
          final asList = [
            for (final visitor in TreeVisitor.visible(tree, TreeVisibility.allCollapsed())) //
              visitor,
          ];

          expect(asList, [TreeVisitorData(parent: null, node: tree, depth: 0, index: 0, last: 0)]);
        });

        test('complex node + all expanded => returns all in order', () async {
          final asList = [
            for (final visitor in TreeVisitor.visible(tree, TreeVisibility.allExpanded())) //
              visitor,
          ];

          expect(asList, [
            TreeVisitorData(parent: null, node: tree, depth: 0, index: 0, last: 0),
            TreeVisitorData(parent: tree, node: a, depth: 1, index: 0, last: 1),
            TreeVisitorData(parent: a, node: a1, depth: 2, index: 0, last: 1),
            TreeVisitorData(parent: a, node: a2, depth: 2, index: 1, last: 1),
            TreeVisitorData(parent: a2, node: a2a, depth: 3, index: 0, last: 0),
            TreeVisitorData(parent: tree, node: b, depth: 1, index: 1, last: 1),
          ]);
        });
      });
    });

    group('flatten', () {
      test('leaf only => returns only it self', () async {
        final tree = TreeLeaf(id: "lr", builder: (_, __) => SizedBox());
        final asList = TreeVisitor.flatten(tree);

        final expected = TreeVisitorData(parent: null, node: tree, depth: 0, index: 0, last: 0);
        expected.skip = 0;

        expect(asList, [expected]);
      });

      test("deep tree => correct skips", () {
        final builder = (context, details) => SizedBox();
        final b = TreeLeaf(id: "b", builder: builder);
        final a2a = TreeLeaf(id: "a2a", builder: builder);
        final a2 = TreeNode(id: "a2", builder: builder, children: [a2a]);
        final a1 = TreeLeaf(id: "a1", builder: builder);
        final a = TreeNode(id: "a", builder: builder, children: [a1, a2]);
        final tree = TreeNode(id: "r", builder: builder, children: [a, b]);

        final actual = TreeVisitor.flatten(tree);

        final expected_tree = TreeVisitorData(parent: null, node: tree, depth: 0, index: 0, last: 0);
        expected_tree.skip = 5;
        final expected_a = TreeVisitorData(parent: tree, node: a, depth: 1, index: 0, last: 1);
        expected_a.skip = 3;
        final expected_a1 = TreeVisitorData(parent: a, node: a1, depth: 2, index: 0, last: 1);
        expected_a1.skip = 0;
        final expected_a2 = TreeVisitorData(parent: a, node: a2, depth: 2, index: 1, last: 1);
        expected_a2.skip = 1;
        final expected_a2a = TreeVisitorData(parent: a2, node: a2a, depth: 3, index: 0, last: 0);
        expected_a2a.skip = 0;
        final expected_b = TreeVisitorData(parent: tree, node: b, depth: 1, index: 1, last: 1);
        expected_b.skip = 0;

        expect(actual, [
          expected_tree,
          expected_a,
          expected_a1,
          expected_a2,
          expected_a2a,
          expected_b,
        ]);
      });
    });
  });
}

class TreeVisibilityNeverCalled implements TreeVisibility {
  bool neverCalled = true;

  TreeVisibilityNeverCalled.any();

  @override
  TreeVisibility collapse(Set<String> ids) {
    neverCalled = false;
    return TreeVisibility.allCollapsed();
  }

  @override
  TreeVisibility collapseAll() {
    neverCalled = false;
    return TreeVisibility.allCollapsed();
  }

  @override
  TreeVisibility expand(Set<String> ids) {
    neverCalled = false;
    return TreeVisibility.allCollapsed();
  }

  @override
  TreeVisibility expandAll() {
    neverCalled = false;
    return TreeVisibility.allCollapsed();
  }

  @override
  Set<String>? get explicit {
    neverCalled = false;
    return null;
  }

  @override
  bool isExpanded(String id) {
    neverCalled = false;
    return false;
  }

  @override
  TreeVisibilityMode get mode {
    neverCalled = false;
    return TreeVisibilityMode.allCollapsed;
  }
}
