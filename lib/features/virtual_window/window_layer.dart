import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_window_frame.dart';
import 'cubit/window_manager_cubit.dart';
import 'virtual_window_widget.dart';
import 'window_content_builder.dart';

/// Renders every open window for the current desktop.
///
/// Windows, macOS and Linux previously each carried a private, near-identical
/// copy of this widget; the only thing that ever differed was the title bar
/// [style] and the chrome each desktop reserves via [insets].
class WindowLayer extends StatelessWidget {
  final WindowButtonStyle style;

  /// Screen edges already occupied by desktop chrome (taskbar, menu bar, dock).
  /// Windows are confined to — and maximize into — the remaining area.
  final EdgeInsets insets;

  /// Clips window content to the frame's bottom corners (Linux/GNOME look).
  final BorderRadius? contentRadius;

  const WindowLayer({
    super.key,
    required this.style,
    this.insets = EdgeInsets.zero,
    this.contentRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: insets.left,
      top: insets.top,
      right: insets.right,
      bottom: insets.bottom,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bounds = Size(constraints.maxWidth, constraints.maxHeight);

          return BlocBuilder<WindowManagerCubit, WindowManagerState>(
            builder: (context, state) {
              return Stack(
                children: [
                  for (final window in state.windows)
                    VirtualWindow(
                      key: ValueKey(window.id),
                      window: window,
                      bounds: bounds,
                      headerBuilder:
                          (context, title, close, minimize, maximize) {
                        return BaseWindowFrame(
                          title: title,
                          onClose: close,
                          onMinimize: minimize,
                          onMaximize: maximize,
                          style: style,
                        );
                      },
                      child: contentRadius != null
                          ? ClipRRect(
                              borderRadius: contentRadius!,
                              child: WindowContentBuilder(
                                content: window.content,
                                windowId: window.id,
                              ),
                            )
                          : WindowContentBuilder(
                              content: window.content,
                              windowId: window.id,
                            ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
