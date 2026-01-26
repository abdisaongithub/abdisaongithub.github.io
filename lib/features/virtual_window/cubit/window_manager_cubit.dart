import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../virtual_window_item.dart';
import '../window_content.dart';

part 'window_manager_state.dart';

class WindowManagerCubit extends Cubit<WindowManagerState> {
  WindowManagerCubit() : super(const WindowManagerState());

  final _uuid = const Uuid();

  void openWindow(WindowContent content) {
    // Check if a window with same type/data already exists & focus it
    final existingIndex = state.windows.indexWhere(
      (w) => w.content.type == content.type && w.content.data == content.data,
    );

    if (existingIndex != -1) {
      focusWindow(state.windows[existingIndex].id);
      return;
    }

    final newWindow = VirtualWindowItem(id: _uuid.v4(), content: content);

    // Unfocus others and add new one on top
    final unfocusedWindows = state.windows
        .map((w) => w.copyWith(isFocused: false))
        .toList();

    emit(state.copyWith(windows: [...unfocusedWindows, newWindow]));
  }

  void closeWindow(String id) {
    final updatedWindows = state.windows.where((w) => w.id != id).toList();
    emit(state.copyWith(windows: updatedWindows));
  }

  void focusWindow(String id) {
    if (state.windows.isEmpty) return;

    final targetWindow = state.windows.firstWhere(
      (w) => w.id == id,
      orElse: () => state.windows.last,
    );

    // Move target to end of list (top z-index) and set focused
    final otherWindows = state.windows
        .where((w) => w.id != id)
        .map((w) => w.copyWith(isFocused: false))
        .toList();

    emit(
      state.copyWith(
        windows: [
          ...otherWindows,
          targetWindow.copyWith(isFocused: true, isMinimized: false),
        ],
      ),
    );
  }

  void minimizeWindow(String id) {
    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        return w.copyWith(isMinimized: true, isFocused: false);
      }
      return w;
    }).toList();
    emit(state.copyWith(windows: updatedWindows));
  }

  void moveWindow(String id, Offset delta) {
    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        return w.copyWith(
          position: w.position + delta,
        );
      }
      return w;
    }).toList();
    emit(state.copyWith(windows: updatedWindows));
  }
}
