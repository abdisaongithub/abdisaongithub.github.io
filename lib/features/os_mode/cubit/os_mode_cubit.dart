import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/platform_detector.dart';
import '../os_mode.dart';

part 'os_mode_state.dart';

class OSModeCubit extends Cubit<OSModeState> {
  /// [detect] is injectable so tests can pin a device instead of depending on
  /// whatever the host reports.
  OSModeCubit({DeviceProfile Function()? detect})
      : super(_initialState((detect ?? PlatformDetector.detect)()));

  static OSModeState _initialState(DeviceProfile device) {
    return OSModeState(
      mode: device.osMode,
      detected: device.osMode,
      isHandset: device.isHandset,
    );
  }

  /// Leaves the landing page and boots [mode].
  ///
  /// The BIOS animation plays here, as a transition into the shell, rather
  /// than as a gate in front of the site's actual content.
  void enterOS(OSMode mode) {
    emit(
      state.copyWith(
        mode: mode,
        isInOS: true,
        isBooting: true,
        isManual: mode != state.detected,
      ),
    );
  }

  void enterDetectedOS() => enterOS(state.detected);

  /// Called by the boot screen once its animation finishes.
  void bootComplete() {
    if (!state.isBooting) return;
    emit(state.copyWith(isBooting: false));
  }

  /// Returns to the landing page.
  void exitToLanding() {
    emit(state.copyWith(isInOS: false, isBooting: false));
  }

  /// Switches shells while already inside the OS. No boot animation — this is
  /// a live switch, and replaying the BIOS every time would be tedious.
  void setMode(OSMode mode) {
    if (mode == state.mode) return;
    emit(state.copyWith(mode: mode, isManual: mode != state.detected));
  }

  /// Returns the visitor to the shell matching their own platform.
  void resetToDetected() {
    emit(state.copyWith(mode: state.detected, isManual: false));
  }

  void toggleMode() {
    final nextIndex = (state.mode.index + 1) % OSMode.values.length;
    setMode(OSMode.values[nextIndex]);
  }
}
