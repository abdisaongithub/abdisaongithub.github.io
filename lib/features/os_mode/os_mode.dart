import 'package:flutter/material.dart';

enum OSMode { windows, macos, linux, android, ios, web }

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
      case OSMode.web:
        return 'Web';
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
      case OSMode.web:
        return Icons.language;
    }
  }

  bool get isMobile => this == OSMode.android || this == OSMode.ios;

  bool get isDesktop =>
      this == OSMode.windows || this == OSMode.macos || this == OSMode.linux;
}
