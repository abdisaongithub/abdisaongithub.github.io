part of 'os_mode_cubit.dart';

class OSModeState extends Equatable {
  /// The shell currently rendering.
  final OSMode mode;

  /// What the visitor is actually running, from [PlatformDetector].
  final OSMode detected;

  /// Whether the real device is a phone-sized touch screen.
  final bool isHandset;

  /// True while the boot transition is playing — on first load, and again
  /// each time the visitor switches to a different shell.
  final bool isBooting;

  /// True once the visitor has picked a shell that is not their own platform.
  final bool isManual;

  const OSModeState({
    required this.mode,
    required this.detected,
    this.isHandset = false,
    this.isBooting = false,
    this.isManual = false,
  });

  bool get isMobileShell => mode.isMobile;

  /// Show the simulated handset frame only when a mobile shell is being
  /// previewed on hardware that is not a phone.
  ///
  /// This used to key off orientation, which meant turning a real phone
  /// sideways wrapped the launcher in a fake phone.
  bool get showsPhoneFrame => isMobileShell && !isHandset;

  /// True when the active shell matches the visitor's own platform.
  bool get isNativeShell => mode == detected;

  OSModeState copyWith({OSMode? mode, bool? isBooting, bool? isManual}) {
    return OSModeState(
      mode: mode ?? this.mode,
      detected: detected,
      isHandset: isHandset,
      isBooting: isBooting ?? this.isBooting,
      isManual: isManual ?? this.isManual,
    );
  }

  @override
  List<Object> get props => [mode, detected, isHandset, isBooting, isManual];
}
