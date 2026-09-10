import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/virtual_window/cubit/window_manager_cubit.dart';
import 'package:flutter_portfolio_app/features/virtual_window/virtual_window_item.dart';
import 'package:flutter_portfolio_app/features/virtual_window/window_content.dart';

const _terminal = WindowContent(
  type: WindowContentType.terminal,
  title: 'Terminal',
);
const _settings = WindowContent(
  type: WindowContentType.settings,
  title: 'Settings',
);

void main() {
  late WindowManagerCubit cubit;

  setUp(() => cubit = WindowManagerCubit());
  tearDown(() => cubit.close());

  group('opening and closing', () {
    test('opens a window and focuses it', () {
      cubit.openWindow(_terminal);

      expect(cubit.state.windows, hasLength(1));
      expect(cubit.state.windows.single.isFocused, isTrue);
    });

    test('reopening the same content focuses instead of duplicating', () {
      cubit.openWindow(_terminal);
      cubit.openWindow(_settings);
      cubit.openWindow(_terminal);

      expect(cubit.state.windows, hasLength(2));
      expect(cubit.state.windows.last.content, _terminal);
      expect(cubit.state.windows.last.isFocused, isTrue);
    });

    test('cascades new windows so they do not stack exactly', () {
      cubit.openWindow(_terminal);
      cubit.openWindow(_settings);

      expect(
        cubit.state.windows.first.position,
        isNot(cubit.state.windows.last.position),
      );
    });

    test('closes only the requested window', () {
      cubit.openWindow(_terminal);
      cubit.openWindow(_settings);
      cubit.closeWindow(cubit.state.windows.first.id);

      expect(cubit.state.windows, hasLength(1));
      expect(cubit.state.windows.single.content, _settings);
    });
  });

  group('focus', () {
    test('brings a window to the top of the z-order', () {
      cubit.openWindow(_terminal);
      final terminalId = cubit.state.windows.first.id;
      cubit.openWindow(_settings);

      cubit.focusWindow(terminalId);

      expect(cubit.state.windows.last.id, terminalId);
      expect(cubit.state.windows.first.isFocused, isFalse);
    });

    test('restores a minimized window', () {
      cubit.openWindow(_terminal);
      final id = cubit.state.windows.single.id;

      cubit.minimizeWindow(id);
      expect(cubit.state.windows.single.isMinimized, isTrue);

      cubit.focusWindow(id);
      expect(cubit.state.windows.single.isMinimized, isFalse);
      expect(cubit.state.windows.single.isFocused, isTrue);
    });

    // Regression: focusWindow used to fall back to `.last`, so a stale id
    // silently focused some unrelated window.
    test('an unknown id changes nothing', () {
      cubit.openWindow(_terminal);
      final before = cubit.state;

      cubit.focusWindow('not-a-real-id');

      expect(cubit.state, before);
    });

    test('focusing with no windows open does not throw', () {
      expect(() => cubit.focusWindow('anything'), returnsNormally);
    });
  });

  group('maximize', () {
    test('toggles and preserves the original geometry', () {
      cubit.openWindow(_terminal);
      final id = cubit.state.windows.single.id;
      final original = cubit.state.windows.single;

      cubit.toggleMaximize(id);
      expect(cubit.state.windows.single.isMaximized, isTrue);
      expect(cubit.state.windows.single.position, original.position);
      expect(cubit.state.windows.single.size, original.size);

      cubit.toggleMaximize(id);
      expect(cubit.state.windows.single.isMaximized, isFalse);
    });

    test('a maximized window ignores drags', () {
      cubit.openWindow(_terminal);
      final id = cubit.state.windows.single.id;
      cubit.toggleMaximize(id);
      final position = cubit.state.windows.single.position;

      cubit.moveWindow(id, const Offset(50, 50), bounds: const Size(1200, 800));

      expect(cubit.state.windows.single.position, position);
    });
  });

  group('move', () {
    const bounds = Size(1200, 800);

    test('applies the drag delta', () {
      cubit.openWindow(_terminal);
      final id = cubit.state.windows.single.id;
      final start = cubit.state.windows.single.position;

      cubit.moveWindow(id, const Offset(40, 25), bounds: bounds);

      expect(cubit.state.windows.single.position, start + const Offset(40, 25));
    });

    // Regression: windows could be dragged entirely off-screen with no way
    // to grab them again.
    test('keeps a grabbable strip on screen when dragged far right', () {
      cubit.openWindow(_terminal);
      final id = cubit.state.windows.single.id;

      cubit.moveWindow(id, const Offset(99999, 0), bounds: bounds);

      expect(
        cubit.state.windows.single.position.dx,
        lessThanOrEqualTo(bounds.width - VirtualWindowItem.minVisible),
      );
    });

    test('never lets the title bar go above the desktop', () {
      cubit.openWindow(_terminal);
      final id = cubit.state.windows.single.id;

      cubit.moveWindow(id, const Offset(0, -99999), bounds: bounds);

      expect(cubit.state.windows.single.position.dy, 0);
    });

    test('keeps part of the window visible when dragged far left', () {
      cubit.openWindow(_terminal);
      final window = cubit.state.windows.single;

      cubit.moveWindow(window.id, const Offset(-99999, 0), bounds: bounds);

      final dx = cubit.state.windows.single.position.dx;
      expect(
          dx + window.size.width,
          greaterThanOrEqualTo(
            VirtualWindowItem.minVisible,
          ));
    });
  });

  group('resize', () {
    const bounds = Size(1200, 800);

    test('grows the window by the drag delta', () {
      cubit.openWindow(_terminal);
      final id = cubit.state.windows.single.id;

      cubit.moveWindow(id, -cubit.state.windows.single.position,
          bounds: bounds);
      cubit.resizeWindow(id, const Offset(100, 50), bounds: bounds);

      expect(cubit.state.windows.single.size.width, 900);
      expect(cubit.state.windows.single.size.height, 650);
    });

    test('refuses to shrink below the minimum size', () {
      cubit.openWindow(_terminal);
      final id = cubit.state.windows.single.id;

      cubit.resizeWindow(id, const Offset(-99999, -99999), bounds: bounds);

      expect(cubit.state.windows.single.size, VirtualWindowItem.minSize);
    });
  });
}
