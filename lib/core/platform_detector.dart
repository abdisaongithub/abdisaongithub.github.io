import 'package:flutter/foundation.dart';

import '../features/os_mode/os_mode.dart';
import 'platform/platform_probe_stub.dart'
    if (dart.library.js_interop) 'platform/platform_probe_web.dart' as probe;

/// What we were able to work out about the visitor's real device.
@immutable
class DeviceProfile {
  /// The OS shell that matches the visitor's actual platform.
  final OSMode osMode;

  /// True for phones — anything that should render a mobile launcher
  /// full-bleed rather than inside a simulated phone frame.
  final bool isHandset;

  const DeviceProfile({required this.osMode, required this.isHandset});

  static const DeviceProfile fallback = DeviceProfile(
    osMode: OSMode.windows,
    isHandset: false,
  );

  @override
  bool operator ==(Object other) =>
      other is DeviceProfile &&
      other.osMode == osMode &&
      other.isHandset == isHandset;

  @override
  int get hashCode => Object.hash(osMode, isHandset);

  @override
  String toString() => 'DeviceProfile($osMode, isHandset: $isHandset)';
}

/// Decides which OS shell a visitor should land on.
///
/// The app previously hardcoded macOS for everyone, so a Windows visitor was
/// greeted by a Mac desktop and a phone visitor by a desktop UI.
class PlatformDetector {
  const PlatformDetector._();

  /// Widest edge we still treat as a handset, in CSS pixels.
  static const double handsetMaxWidth = 600;

  static DeviceProfile detect() {
    try {
      return DeviceProfile(osMode: _detectOS(), isHandset: _detectHandset());
    } catch (_) {
      // Never let detection break boot — any failure just lands on the default.
      return DeviceProfile.fallback;
    }
  }

  /// Exposed for testing: maps a platform + touch capability to a shell.
  @visibleForTesting
  static OSMode osModeFor(TargetPlatform platform, {required bool hasTouch}) {
    switch (platform) {
      case TargetPlatform.android:
        return OSMode.android;
      case TargetPlatform.iOS:
        return OSMode.ios;
      case TargetPlatform.windows:
        return OSMode.windows;
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return OSMode.linux;
      case TargetPlatform.macOS:
        // iPadOS 13+ ships a desktop-class user agent, so Flutter reports
        // macOS for iPads. A Mac has no touch screen; an iPad does.
        return hasTouch ? OSMode.ios : OSMode.macos;
    }
  }

  static OSMode _detectOS() => osModeFor(
        defaultTargetPlatform,
        hasTouch: probe.isTouchDevice(),
      );

  static bool _detectHandset() {
    if (!probe.isTouchDevice()) return false;
    return probe.shortestScreenSide() <= handsetMaxWidth;
  }
}
