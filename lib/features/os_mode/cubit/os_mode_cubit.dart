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

  void setMode(OSMode mode) {
    if (mode == state.mode) return;
    emit(state.copyWith(mode: mode, isManual: true));
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
