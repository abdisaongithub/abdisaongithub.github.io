import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../os_mode.dart';

part 'os_mode_state.dart';

class OSModeCubit extends Cubit<OSModeState> {
  OSModeCubit()
    : super(const OSModeState(OSMode.windows)); // Default to Windows

  void setMode(OSMode mode) {
    emit(OSModeState(mode));
  }

  void toggleMode() {
    // Logic to cycle through modes for testing
    final nextIndex = (state.mode.index + 1) % OSMode.values.length;
    emit(OSModeState(OSMode.values[nextIndex]));
  }
}
