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
