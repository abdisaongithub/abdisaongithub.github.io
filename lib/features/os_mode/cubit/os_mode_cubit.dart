import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../os_mode.dart';

part 'os_mode_state.dart';

class OSModeCubit extends Cubit<OSModeState> {
  OSModeCubit() : super(const OSModeState(OSMode.macos, isManual: false));

  void setMode(OSMode mode, {bool isManual = true}) {
    // If switching between mobile modes (e.g. Android -> iOS),
    // we assume the user wants to maintain the current "native" adaptive state
    // rather than forcing a manual simulation frame.
    final isCurrentMobile =
        state.mode == OSMode.android || state.mode == OSMode.ios;
    final isNewMobile = mode == OSMode.android || mode == OSMode.ios;

    if (isCurrentMobile && isNewMobile) {
      // Inherit the current manual state.
      // If we were in "Native Mode" (isManual: false), keep it false.
      // If we were in "Simulation Mode" (isManual: true), keep it true (don't lose the frame).
      isManual = state.isManual;
    }

    emit(OSModeState(mode, isManual: isManual));
  }

  void toggleMode() {
    final nextIndex = (state.mode.index + 1) % OSMode.values.length;
    emit(OSModeState(OSMode.values[nextIndex], isManual: true));
  }
}
