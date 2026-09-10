import 'package:flutter/material.dart';
import '../../virtual_window/base_window_frame.dart';
import '../../virtual_window/window_layer.dart';
import '../../virtual_window/window_task_strip.dart';
import '../../apps/app_enums.dart';
import '../../apps/app_launcher_service.dart';
import '../../apps/widgets/spotify_widget.dart';

const double _kTopBarHeight = 28;
const double _kDockWidth = 48;

class LinuxDesktop extends StatelessWidget {
  const LinuxDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        // Ubuntu purple
        scaffoldBackgroundColor: const Color(0xFF300A24),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Ubuntu Gradient Wallpaper
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE95420), Color(0xFF300A24)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),

            // Window Manager
            const WindowLayer(
              style: WindowButtonStyle.linux,
              insets: EdgeInsets.only(top: _kTopBarHeight, left: _kDockWidth),
              contentRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),

            // Top Bar
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _kTopBarHeight,
              child: _UbuntuTopBar(),
            ),

            // Side Dock
            const Positioned(
              top: _kTopBarHeight,
              left: 0,
              bottom: 0,
              width: _kDockWidth,
              child: _UbuntuDock(),
            ),
          ],
        ),
      ),
    );
  }
}

class _UbuntuTopBar extends StatelessWidget {
  const _UbuntuTopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: const Row(
        children: [
          Text(
            'Activities',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          Spacer(),
          SpotifyWidget(),
          Spacer(),
          Icon(Icons.wifi, color: Colors.white, size: 14),
          SizedBox(width: 8),
          Icon(Icons.battery_std, color: Colors.white, size: 14),
          SizedBox(width: 8),
          Icon(Icons.power_settings_new, color: Colors.white, size: 14),
        ],
      ),
    );
  }
}

class _UbuntuDock extends StatelessWidget {
  const _UbuntuDock();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _DockAppIcon(
            icon: Icons.folder,
            color: Colors.orange,
            tooltip: 'Files',
            onTap: () => AppLauncherService.launch(context, AppType.projects),
          ),
          _DockAppIcon(
            icon: Icons.terminal,
            color: Colors.white,
            tooltip: 'Terminal',
            onTap: () => AppLauncherService.launch(context, AppType.terminal),
          ),
          _DockAppIcon(
            icon: Icons.code,
            color: Colors.lightBlue,
            tooltip: 'VS Code',
            onTap: () => AppLauncherService.launch(context, AppType.code),
          ),
          _DockAppIcon(
            icon: Icons.settings,
            color: Colors.grey,
            tooltip: 'Settings',
            onTap: () => AppLauncherService.launch(context, AppType.settings),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: Colors.white.withValues(alpha: 0.3),
          ),
          // Running windows, so a minimized window can be reopened.
          const WindowTaskStrip(axis: Axis.vertical),
          const Spacer(),
          _DockAppIcon(
            icon: Icons.apps,
            color: Colors.white,
            tooltip: 'Show Applications',
            onTap: () => AppLauncherService.launch(context, AppType.projects),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DockAppIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _DockAppIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
      ),
    );
  }
}
