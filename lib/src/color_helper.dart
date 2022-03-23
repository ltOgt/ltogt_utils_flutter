import 'dart:ui';

class ColorHelper {
  static String toHexString(Color color) {
    return "0x" + color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  static Color fromHexString(String hex) {
    return Color(int.parse(hex));
  }
}
