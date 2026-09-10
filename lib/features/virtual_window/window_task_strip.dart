import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/window_manager_cubit.dart';
import 'window_content.dart';

/// Shows one entry per open window so a minimized window can always be brought
/// back. Without this, minimizing was effectively "close with no undo".
class WindowTaskStrip extends StatelessWidget {
  final Axis axis;
  final Color accent;

  const WindowTaskStrip({
    super.key,
    this.axis = Axis.horizontal,
    this.accent = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WindowManagerCubit, WindowManagerState>(
      builder: (context, state) {
        if (state.windows.isEmpty) return const SizedBox.shrink();

        final entries = <Widget>[
          for (final window in state.windows)
            _TaskButton(
              icon: window.content.type.icon,
              label: window.content.title,
              isFocused: window.isFocused && !window.isMinimized,
              isMinimized: window.isMinimized,
              accent: accent,
              onTap: () {
                final cubit = context.read<WindowManagerCubit>();
                // Clicking the active window tucks it away, like a real taskbar.
                if (window.isFocused && !window.isMinimized) {
                  cubit.minimizeWindow(window.id);
                } else {
                  cubit.focusWindow(window.id);
                }
              },
            ),
        ];

        return axis == Axis.horizontal
            ? Row(mainAxisSize: MainAxisSize.min, children: entries)
            : Column(mainAxisSize: MainAxisSize.min, children: entries);
      },
    );
  }
}

class _TaskButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isFocused;
  final bool isMinimized;
  final Color accent;
  final VoidCallback onTap;

  const _TaskButton({
    required this.icon,
    required this.label,
    required this.isFocused,
    required this.isMinimized,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_TaskButton> createState() => _TaskButtonState();
}

class _TaskButtonState extends State<_TaskButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message:
            widget.isMinimized ? '${widget.label} (minimized)' : widget.label,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            decoration: BoxDecoration(
              color: widget.isFocused
                  ? widget.accent.withValues(alpha: 0.18)
                  : (_hovering
                      ? widget.accent.withValues(alpha: 0.10)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: widget.accent.withValues(
                    alpha: widget.isMinimized ? 0.55 : 1.0,
                  ),
                ),
                // Running indicator, mirroring Windows 11 / GNOME behaviour.
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: widget.isFocused ? 14 : 6,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(
                        alpha: widget.isMinimized ? 0.4 : 0.9,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
