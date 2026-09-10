import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/platform_detector.dart';
import '../os_mode.dart';

part 'os_mode_state.dart';

class OSModeCubit extends Cubit<OSModeState> {
  /// [detect] is injectable so tests can pin a device instead of depending on
  /// whatever the host reports.
  ///
  /// The app boots straight into the visitor's own platform: a Windows visitor
  /// lands in Windows, an iPhone in iOS.
  OSModeCubit({DeviceProfile Function()? detect})
      : super(_initialState((detect ?? PlatformDetector.detect)()));

  static OSModeState _initialState(DeviceProfile device) {
    return OSModeState(
      mode: device.osMode,
      detected: device.osMode,
      isHandset: device.isHandset,
      // The BIOS transition plays on arrival.
      isBooting: true,
    );
  }

  /// Called by the boot screen once its animation finishes.
  void bootComplete() {
    if (!state.isBooting) return;
    emit(state.copyWith(isBooting: false));
  }

  /// Switches shells. The boot transition replays, which is the point — the
  /// visitor asked to see another operating system start up.
  void setMode(OSMode mode) {
    if (mode == state.mode) return;
    emit(
      state.copyWith(
        mode: mode,
        isBooting: true,
        isManual: mode != state.detected,
      ),
    );
  }

  /// Returns the visitor to the shell matching their own platform.
  void resetToDetected() {
    if (state.mode == state.detected) return;
    emit(
      state.copyWith(
        mode: state.detected,
        isBooting: true,
        isManual: false,
      ),
    );
  }

  void toggleMode() {
    final nextIndex = (state.mode.index + 1) % OSMode.values.length;
    setMode(OSMode.values[nextIndex]);
  }
}
