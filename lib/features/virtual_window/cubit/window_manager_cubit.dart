import 'dart:math' as math;

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

  /// Cascade offset so a second window does not land exactly on the first.
  static const Offset _cascadeStep = Offset(28, 28);
  static const int _cascadeWrap = 6;

  void openWindow(WindowContent content) {
    // Check if a window with same type/data already exists & focus it
    final existingIndex = state.windows.indexWhere(
      (w) => w.content.type == content.type && w.content.data == content.data,
    );

    if (existingIndex != -1) {
      focusWindow(state.windows[existingIndex].id);
      return;
    }

    final step = state.windows.length % _cascadeWrap;
    final newWindow = VirtualWindowItem(
      id: _uuid.v4(),
      content: content,
      position: const Offset(100, 100) + _cascadeStep * step.toDouble(),
    );

    // Unfocus others and add new one on top
    final unfocusedWindows =
        state.windows.map((w) => w.copyWith(isFocused: false)).toList();

    emit(state.copyWith(windows: [...unfocusedWindows, newWindow]));
  }

  void closeWindow(String id) {
    final updatedWindows = state.windows.where((w) => w.id != id).toList();
    emit(state.copyWith(windows: updatedWindows));
  }

  void focusWindow(String id) {
    final targetIndex = state.windows.indexWhere((w) => w.id == id);
    // Silently focusing some *other* window on a stale id is worse than
    // doing nothing, so bail out instead of falling back to `.last`.
    if (targetIndex == -1) return;

    final targetWindow = state.windows[targetIndex];

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

  /// Toggles between the window's own geometry and filling the desktop.
  /// The original position/size is preserved so restoring is lossless.
  void toggleMaximize(String id) {
    final updatedWindows = state.windows.map((w) {
      if (w.id == id) {
        return w.copyWith(isMaximized: !w.isMaximized, isMinimized: false);
      }
      return w;
    }).toList();
    emit(state.copyWith(windows: updatedWindows));
    focusWindow(id);
  }

  void moveWindow(String id, Offset delta, {Size? bounds}) {
    final updatedWindows = state.windows.map((w) {
      if (w.id != id || w.isMaximized) return w;
      return w.copyWith(position: _clamp(w.position + delta, w.size, bounds));
    }).toList();
    emit(state.copyWith(windows: updatedWindows));
  }

  void resizeWindow(String id, Offset delta, {Size? bounds}) {
    final updatedWindows = state.windows.map((w) {
      if (w.id != id || w.isMaximized) return w;

      var width = w.size.width + delta.dx;
      var height = w.size.height + delta.dy;

      width = math.max(VirtualWindowItem.minSize.width, width);
      height = math.max(VirtualWindowItem.minSize.height, height);

      if (bounds != null) {
        width = math.min(width, bounds.width - w.position.dx);
        height = math.min(height, bounds.height - w.position.dy);
        width = math.max(VirtualWindowItem.minSize.width, width);
        height = math.max(VirtualWindowItem.minSize.height, height);
      }

      return w.copyWith(size: Size(width, height));
    }).toList();
    emit(state.copyWith(windows: updatedWindows));
  }

  /// Keeps a draggable strip of the title bar inside the viewport at all times.
  Offset _clamp(Offset position, Size size, Size? bounds) {
    if (bounds == null) return position;

    const visible = VirtualWindowItem.minVisible;
    final minX = visible - size.width;
    final maxX = bounds.width - visible;
    final maxY = bounds.height - visible;

    return Offset(
      position.dx.clamp(minX, math.max(minX, maxX)),
      position.dy.clamp(0.0, math.max(0.0, maxY)),
    );
  }
}
