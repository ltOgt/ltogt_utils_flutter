import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ltogt_utils_flutter/src/color_helper.dart';

void main() {
  group('ColorHelper', () {
    test('toString', () async {
      expect(ColorHelper.toHexString(Color(0x00000000)), equals("0x00000000"));
      expect(ColorHelper.toHexString(Color(0x01234567)), equals("0x01234567"));
      expect(ColorHelper.toHexString(Color(0xFFFFFFFF)), equals("0xFFFFFFFF"));
    });

    test('fromString', () async {
      expect(ColorHelper.fromHexString("0x00000000"), equals(Color(0x00000000)));
      expect(ColorHelper.fromHexString("0x01234567"), equals(Color(0x01234567)));
      expect(ColorHelper.fromHexString("0xFFFFFFFF"), equals(Color(0xFFFFFFFF)));
    });

    test('round trip', () async {
      expect(ColorHelper.toHexString(ColorHelper.fromHexString("0x00000000")), equals("0x00000000"));
      expect(ColorHelper.toHexString(ColorHelper.fromHexString("0x01234567")), equals("0x01234567"));
      expect(ColorHelper.toHexString(ColorHelper.fromHexString("0xFFFFFFFF")), equals("0xFFFFFFFF"));
      expect(ColorHelper.fromHexString(ColorHelper.toHexString(Color(0x00000000))), equals(Color(0x00000000)));
      expect(ColorHelper.fromHexString(ColorHelper.toHexString(Color(0x01234567))), equals(Color(0x01234567)));
      expect(ColorHelper.fromHexString(ColorHelper.toHexString(Color(0xFFFFFFFF))), equals(Color(0xFFFFFFFF)));
    });
  });
}
