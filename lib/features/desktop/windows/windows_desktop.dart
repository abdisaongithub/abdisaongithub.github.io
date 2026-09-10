import 'package:flutter/material.dart';
import '../../virtual_window/base_window_frame.dart';
import '../../virtual_window/window_layer.dart';
import '../../virtual_window/window_task_strip.dart';
import '../../apps/app_enums.dart';
import '../../apps/app_launcher_service.dart';
import '../../apps/widgets/github_status_widget.dart';
import '../../apps/widgets/spotify_widget.dart';
import '../desktop_wallpaper.dart';

const double _kTaskbarHeight = 48;

// CUSTOM HIGH-FIDELITY WINDOWS THEME
class WindowsDesktop extends StatelessWidget {
  const WindowsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        // Windows font if available, fallback to default
        fontFamily: 'Segoe UI',
        brightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Wallpaper
            const Positioned.fill(child: DesktopWallpaper()),

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
                    icon: Icons.person_outline,
                    onTap: () => AppLauncherService.launch(context, AppType.cv),
                  ),
                  const SizedBox(height: 20),
                  _Win11Icon(
                    label: 'Projects',
                    icon: Icons.folder_open_outlined,
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.projects),
                  ),
                  const SizedBox(height: 20),
                  _Win11Icon(
                    label: 'Terminal',
                    icon: Icons.terminal,
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.terminal),
                  ),
                  const SizedBox(height: 20),
                  _Win11Icon(
                    label: 'VS Code',
                    icon: Icons.code,
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.code),
                  ),
                ],
              ),
            ),

            // Window Manager Layer
            const WindowLayer(
              style: WindowButtonStyle.windows,
              insets: EdgeInsets.only(bottom: _kTaskbarHeight),
            ),

            // Taskbar
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: _kTaskbarHeight,
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
            color: _hovering
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _hovering
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.transparent,
            ),
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
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
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
        // Mica-like transparency
        color: const Color(0xFF202020).withValues(alpha: 0.85),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TaskbarIcon(
                    icon: Icons.window,
                    color: const Color(0xFF00ADEF),
                    tooltip: 'Start',
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.projects),
                  ),
                  const SizedBox(width: 4),
                  _TaskbarIcon(
                    icon: Icons.terminal,
                    color: Colors.white,
                    tooltip: 'Terminal',
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.terminal),
                  ),
                  const SizedBox(width: 4),
                  _TaskbarIcon(
                    icon: Icons.settings,
                    color: Colors.white,
                    tooltip: 'Settings',
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.settings),
                  ),
                  // Open windows live here, so minimizing is always reversible.
                  const WindowTaskStrip(),
                ],
              ),
            ),
          ),
          const Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpotifyWidget(),
                SizedBox(width: 12),
                GithubStatusWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskbarIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _TaskbarIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
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
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _hovering
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(widget.icon, color: widget.color, size: 24),
          ),
        ),
      ),
    );
  }
}
