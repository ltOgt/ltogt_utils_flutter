/// class MyModel extends MPropModel {
///   final myInt = MProp(0);
///   final myStr = MProp("a");
/// }
///
/// void main () {
///   final m = MyModel();
///   m.once((m) {
///     m.myInt.update((v) => v + v);
///     m.myStr.update((v) => v + v);
///   });
///

import 'package:flutter_test/flutter_test.dart';
import 'package:ltogt_utils_flutter/src/state/model/m_prop.dart';

class _MyModel extends MPropModel<_MyModel> {
  late final myInt = MProp(1, this);
  late final myStr = MProp("a", this);
}

void main() {
  group('MPropModel', () {
    test('update twice when called independently', () async {
      final m = _MyModel();

      int countM = 0, countI = 0, countS = 0;

      m.addListener(() {
        countM += 1;
      });
      m.myInt.addListener(() {
        countI += 1;
      });
      m.myStr.addListener(() {
        countS += 1;
      });

      m.myInt.update((c) => c + c);
      m.myStr.update((c) => c + c);

      expect(countM, equals(2));
      expect(countI, equals(1));
      expect(countS, equals(1));
    });

    test('update once when called inside once', () async {
      final m = _MyModel();

      int countM = 0, countI = 0, countS = 0;
      m.addListener(() {
        countM += 1;
      });
      m.myInt.addListener(() {
        countI += 1;
      });
      m.myStr.addListener(() {
        countS += 1;
      });

      m.once((m) {
        m.myInt.update((c) => c + c);
        m.myStr.update((c) => c + c);
      });

      expect(countM, equals(1));
      expect(countI, equals(1));
      expect(countS, equals(1));
    });
  });
}
