part of 'os_mode_cubit.dart';

class OSModeState extends Equatable {
  /// The shell that renders when [isInOS] is true.
  final OSMode mode;

  /// What the visitor is actually running, from [PlatformDetector].
  final OSMode detected;

  /// Whether the real device is a phone-sized touch screen.
  final bool isHandset;

  /// False on the landing page, true inside an OS shell.
  ///
  /// The landing page is the default: a recruiter sees real content
  /// immediately instead of a BIOS animation and a login screen.
  final bool isInOS;

  /// True while the boot transition is playing.
  final bool isBooting;

  /// True once the visitor has picked a shell that is not their own platform.
  final bool isManual;

  const OSModeState({
    required this.mode,
    required this.detected,
    this.isHandset = false,
    this.isInOS = false,
    this.isBooting = false,
    this.isManual = false,
  });

  bool get isMobileShell => mode.isMobile;

  /// Show the simulated handset frame only when a mobile shell is being
  /// previewed on hardware that is not a phone.
  ///
  /// This used to key off orientation, which meant turning a real phone
  /// sideways wrapped the launcher in a fake phone.
  bool get showsPhoneFrame => isInOS && isMobileShell && !isHandset;

  /// True when the active shell matches the visitor's own platform.
  bool get isNativeShell => mode == detected;

  OSModeState copyWith({
    OSMode? mode,
    bool? isInOS,
    bool? isBooting,
    bool? isManual,
  }) {
    return OSModeState(
      mode: mode ?? this.mode,
      detected: detected,
      isHandset: isHandset,
      isInOS: isInOS ?? this.isInOS,
      isBooting: isBooting ?? this.isBooting,
      isManual: isManual ?? this.isManual,
    );
  }

  @override
  List<Object> get props => [
        mode,
        detected,
        isHandset,
        isInOS,
        isBooting,
        isManual,
      ];
}
