import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/window_manager_cubit.dart';
import 'virtual_window_item.dart';

class VirtualWindow extends StatelessWidget {
  final VirtualWindowItem window;
  final Widget child;
  final Widget Function(
    BuildContext,
    String title,
    VoidCallback close,
    VoidCallback minimize,
    VoidCallback maximize,
  )
  headerBuilder;

  const VirtualWindow({
    super.key,
    required this.window,
    required this.child,
    required this.headerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (window.isMinimized) return const SizedBox.shrink();

    return Positioned(
      left: window.position.dx,
      top: window.position.dy,
      width: window.size.width,
      height: window.size.height,
      child: GestureDetector(
        onTap: () {
          context.read<WindowManagerCubit>().focusWindow(window.id);
        },
        child: Material(
          elevation: window.isFocused ? 10.0 : 4.0,
          color: Colors.transparent, // Let decorations handle color
          child: Column(
            children: [
              // Title Bar / Header (Draggable)
              GestureDetector(
                onPanStart: (_) {
                  context.read<WindowManagerCubit>().focusWindow(window.id);
                },
                onPanUpdate: (details) {
                  context
                      .read<WindowManagerCubit>()
                      .moveWindow(window.id, details.delta);
                },
                child: headerBuilder(
                  context,
                  window.content.title,
                  () =>
                      context.read<WindowManagerCubit>().closeWindow(window.id),
                  () => context.read<WindowManagerCubit>().minimizeWindow(
                    window.id,
                  ),
                  () {}, // Maximize not implemented yet
                ),
              ),
              // Content
              Expanded(child: ClipRect(child: child)),
            ],
          ),
        ),
      ),
    );
  }
}
