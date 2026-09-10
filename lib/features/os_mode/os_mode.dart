import 'package:flutter/material.dart';

/// The operating-system shells the app can render.
///
/// `web` used to be a member here — a landing page pretending to be an OS.
/// The landing page is now the default surface rather than one shell among
/// six, so it lives outside this enum (see [OSModeState.isInOS]).
enum OSMode { windows, macos, linux, android, ios }

extension OSModeInfo on OSMode {
  /// Human-facing name. `mode.name.toUpperCase()` used to render these as
  /// "MACOS" and "IOS".
  String get label {
    switch (this) {
      case OSMode.windows:
        return 'Windows 11';
      case OSMode.macos:
        return 'macOS';
      case OSMode.linux:
        return 'Ubuntu';
      case OSMode.android:
        return 'Android';
      case OSMode.ios:
        return 'iOS';
    }
  }

  /// Short name, for chips and other tight spots.
  String get shortLabel => this == OSMode.windows ? 'Windows' : label;

  IconData get icon {
    switch (this) {
      case OSMode.windows:
        return Icons.window;
      case OSMode.macos:
        return Icons.laptop_mac;
      // Not Icons.terminal — that already means "Terminal app" everywhere else.
      case OSMode.linux:
        return Icons.dvr_outlined;
      case OSMode.android:
        return Icons.android;
      case OSMode.ios:
        return Icons.phone_iphone;
    }
  }

  bool get isMobile => this == OSMode.android || this == OSMode.ios;

  bool get isDesktop =>
      this == OSMode.windows || this == OSMode.macos || this == OSMode.linux;
}
