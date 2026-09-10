import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/window_manager_cubit.dart';
import 'virtual_window_item.dart';

class VirtualWindow extends StatelessWidget {
  final VirtualWindowItem window;
  final Widget child;

  /// Size of the desktop area the window lives in. Used to clamp dragging and
  /// to lay out a maximized window.
  final Size bounds;
  final Widget Function(
    BuildContext,
    String title,
    VoidCallback close,
    VoidCallback minimize,
    VoidCallback maximize,
  ) headerBuilder;

  const VirtualWindow({
    super.key,
    required this.window,
    required this.child,
    required this.bounds,
    required this.headerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (window.isMinimized) return const SizedBox.shrink();

    final cubit = context.read<WindowManagerCubit>();
    final isMaximized = window.isMaximized;

    return Positioned(
      left: isMaximized ? 0 : window.position.dx,
      top: isMaximized ? 0 : window.position.dy,
      width: isMaximized ? bounds.width : window.size.width,
      height: isMaximized ? bounds.height : window.size.height,
      child: GestureDetector(
        onTap: () => cubit.focusWindow(window.id),
        child: Material(
          elevation: window.isFocused ? 10.0 : 4.0,
          color: Colors.transparent, // Let decorations handle color
          child: Stack(
            children: [
              Column(
                children: [
                  // Title Bar / Header (Draggable)
                  GestureDetector(
                    onPanStart: (_) => cubit.focusWindow(window.id),
                    onPanUpdate: (details) => cubit.moveWindow(
                      window.id,
                      details.delta,
                      bounds: bounds,
                    ),
                    onDoubleTap: () => cubit.toggleMaximize(window.id),
                    child: headerBuilder(
                      context,
                      window.content.title,
                      () => cubit.closeWindow(window.id),
                      () => cubit.minimizeWindow(window.id),
                      () => cubit.toggleMaximize(window.id),
                    ),
                  ),
                  // Content
                  Expanded(child: ClipRect(child: child)),
                ],
              ),
              if (!isMaximized)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _ResizeHandle(
                    onDrag: (delta) => cubit.resizeWindow(
                      window.id,
                      delta,
                      bounds: bounds,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResizeHandle extends StatelessWidget {
  final ValueChanged<Offset> onDrag;

  const _ResizeHandle({required this.onDrag});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeDownRight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) => onDrag(details.delta),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CustomPaint(painter: _ResizeGripPainter()),
        ),
      ),
    );
  }
}

class _ResizeGripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var i = 1; i <= 3; i++) {
      final offset = i * 4.0;
      canvas.drawLine(
        Offset(size.width - offset, size.height - 2),
        Offset(size.width - 2, size.height - offset),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
