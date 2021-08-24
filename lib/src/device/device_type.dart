import 'package:flutter/foundation.dart';

/// Very much WIP solution for finding out which platform the app is running on
// TODO-2 this is not a strong check! kIsWeb might be mobile web and Platform.isFuchsia might be either mobile/embedded/desktop/...
// ______ maybe need this in combination with screen size (but window size on desktop and web might be similar to mobile....)
// __ for now mobile web is probably not at all on my radar
class DeviceType {
  static bool get isDesktop => [
        TargetPlatform.linux,
        TargetPlatform.windows,
        TargetPlatform.macOS,
        TargetPlatform.fuchsia,
      ].contains(defaultTargetPlatform);

  static bool get isMobile => !isDesktop;
}
