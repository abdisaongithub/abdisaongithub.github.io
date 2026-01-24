import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../virtual_window/cubit/window_manager_cubit.dart';
import '../../virtual_window/window_content.dart';
import '../../virtual_window/virtual_window_widget.dart';

// CUSTOM HIGH-FIDELITY WINDOWS THEME
class WindowsDesktop extends StatelessWidget {
  const WindowsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily:
            'Segoe UI', // Windows font if available, fallback to default
        brightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Wallpaper
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/windows_wallpaper.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Image.asset('assets/images/win11_wallpaper.jpg', fit: BoxFit.cover),
              ),
            ),

            // Desktop Icons
            Positioned(
              left: 20,
              top: 20,
              bottom: 60,
              width: 100,
              child: Column(
                children: [
                  _Win11Icon(
                    label: 'About Me',
                    icon: Icons.person_outline, // Closest to Fluent "Contact"
                    onTap: () {
                      context.read<WindowManagerCubit>().openWindow(
                            const WindowContent(
                              type: WindowContentType.profile,
                              title: 'About Me',
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 20),
                  _Win11Icon(
                    label: 'Projects',
                    icon: Icons.folder_open_outlined,
                    onTap: () {
                      context.read<WindowManagerCubit>().openWindow(
                            const WindowContent(
                              type: WindowContentType.projectDetail,
                              title: 'Projects',
                              data: 'All',
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),

            // Window Manager Layer
            const _WindowsWindowManager(),

            // Taskbar
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 48,
              child: _Win11Taskbar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Win11Icon extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _Win11Icon({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_Win11Icon> createState() => _Win11IconState();
}

class _Win11IconState extends State<_Win11Icon> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color:
                _hovering ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: _hovering
                ? Border.all(color: Colors.white.withOpacity(0.2))
                : Border.all(color: Colors.transparent),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 30, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  shadows: [
                    Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Win11Taskbar extends StatelessWidget {
  const _Win11Taskbar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            const Color(0xFF202020).withOpacity(0.85), // Mica-like transparency
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TaskbarIcon(
                  icon: Icons.window,
                  color: const Color(0xFF00ADEF),
                  onTap: () {}), // Start
              const SizedBox(width: 8),
              _TaskbarIcon(
                  icon: Icons.search, color: Colors.white, onTap: () {}),
              const SizedBox(width: 8),
              _TaskbarIcon(
                  icon: Icons.web_asset,
                  color: Colors.white,
                  onTap: () {}), // Task view
              const SizedBox(width: 8),
              _TaskbarIcon(
                  icon: Icons.chat_bubble_outline,
                  color: Colors.white,
                  onTap: () {}), // Chat
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskbarIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TaskbarIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_TaskbarIcon> createState() => _TaskbarIconState();
}

class _TaskbarIconState extends State<_TaskbarIcon> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                _hovering ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(widget.icon, color: widget.color, size: 24),
        ),
      ),
    );
  }
}

class _WindowsWindowManager extends StatelessWidget {
  const _WindowsWindowManager();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WindowManagerCubit, WindowManagerState>(
      builder: (context, state) {
        return Stack(
          children: state.windows
              .map((window) {
                return VirtualWindow(
                  key: ValueKey(window.id),
                  window: window,
                  headerBuilder: (context, title, close, minimize, maximize) {
                    // High-Fidelity Windows 11 Title Bar
                    return Container(
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          _WindowCaptionButton(
                            icon: Icons.remove,
                            onPressed: minimize,
                          ),
                          _WindowCaptionButton(
                            icon: Icons.check_box_outline_blank, // Square
                            onPressed: maximize,
                          ),
                          _WindowCaptionButton(
                            icon: Icons.close,
                            onPressed: close,
                            isCloseBtn: true,
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    color: const Color(0xFFF9F9F9), // Windows 11 light bg
                    child: Center(
                      child: Text(
                        "Content: ${window.content.type}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              })
              .toList()
              .cast<Widget>(),
        );
      },
    );
  }
}

class _WindowCaptionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isCloseBtn;

  const _WindowCaptionButton({
    required this.icon,
    required this.onPressed,
    this.isCloseBtn = false,
  });

  @override
  State<_WindowCaptionButton> createState() => _WindowCaptionButtonState();
}

class _WindowCaptionButtonState extends State<_WindowCaptionButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 46,
          height: 32,
          color: _hovering
              ? (widget.isCloseBtn
                  ? const Color(0xFFC42B1C)
                  : const Color(0xFFE5E5E5))
              : Colors.transparent,
          child: Icon(
            widget.icon,
            size: 14,
            color: _hovering && widget.isCloseBtn ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
