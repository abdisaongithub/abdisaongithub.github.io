part of 'os_mode_cubit.dart';

class OSModeState extends Equatable {
  /// The shell currently being rendered.
  final OSMode mode;

  /// What the visitor is actually running, from [PlatformDetector].
  final OSMode detected;

  /// Whether the real device is a phone-sized touch screen.
  final bool isHandset;

  /// True once the visitor has picked a mode themselves, so we stop treating
  /// the shell as "theirs".
  final bool isManual;

  const OSModeState({
    required this.mode,
    required this.detected,
    this.isHandset = false,
    this.isManual = false,
  });

  bool get isMobileShell => mode == OSMode.android || mode == OSMode.ios;

  /// Show the simulated handset frame only when a mobile shell is being
  /// previewed on hardware that is not a phone.
  ///
  /// This used to key off orientation, which meant turning a real phone
  /// sideways wrapped the launcher in a fake phone.
  bool get showsPhoneFrame => isMobileShell && !isHandset;

  /// True when the active shell matches the visitor's own platform.
  bool get isNativeShell => mode == detected;

  OSModeState copyWith({OSMode? mode, bool? isManual}) {
    return OSModeState(
      mode: mode ?? this.mode,
      detected: detected,
      isHandset: isHandset,
      isManual: isManual ?? this.isManual,
    );
  }

  @override
  List<Object> get props => [mode, detected, isHandset, isManual];
}
