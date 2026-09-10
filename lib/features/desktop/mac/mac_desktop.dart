import 'package:flutter/material.dart';
import '../../../core/live_clock.dart';
import '../../virtual_window/base_window_frame.dart';
import '../../virtual_window/window_layer.dart';
import '../../virtual_window/window_task_strip.dart';
import '../../apps/app_enums.dart';
import '../../apps/app_launcher_service.dart';
import '../../apps/now_playing/now_playing_widget.dart';
import '../../apps/widgets/github_status_widget.dart';
import '../desktop_wallpaper.dart';

const double _kMenuBarHeight = 24;
const double _kDockReserved = 88;

class MacDesktop extends StatelessWidget {
  const MacDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        // Attempt Mac font
        fontFamily: '.SF Pro Text',
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Wallpaper
            const Positioned.fill(child: DesktopWallpaper()),

            // Window Manager — sits above the wallpaper but below the chrome.
            const WindowLayer(
              style: WindowButtonStyle.mac,
              insets: EdgeInsets.only(
                top: _kMenuBarHeight,
                bottom: _kDockReserved,
              ),
            ),

            // Top Menu Bar
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _kMenuBarHeight,
              child: _MacMenuBar(),
            ),

            // Dock
            const Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(child: _MacDock()),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacMenuBar extends StatelessWidget {
  const _MacMenuBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 640;

          return Row(
            children: [
              const Icon(Icons.apple, color: Colors.white, size: 15),
              const SizedBox(width: 14),
              const Text(
                'Finder',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  height: 1.0,
                ),
              ),
              if (!isNarrow) ...[
                const SizedBox(width: 16),
                const Text(
                  'File',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.0,
                  ),
                ),
              ],
              const Spacer(),
              // Compact: the full card is 44px tall and this bar is 24px.
              if (!isNarrow) ...[
                const NowPlayingWidget(variant: NowPlayingVariant.compact),
                const SizedBox(width: 14),
                const GithubStatusWidget(),
                const SizedBox(width: 14),
              ],
              const Icon(Icons.wifi, color: Colors.white, size: 14),
              const SizedBox(width: 12),
              const LiveClock(showMeridiem: true),
            ],
          );
        },
      ),
    );
  }
}

class _MacDock extends StatelessWidget {
  const _MacDock();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DockItem(
            icon: Icons.face,
            color: Colors.blue,
            tooltip: 'About Me',
            onTap: () => AppLauncherService.launch(context, AppType.cv),
          ),
          _DockItem(
            icon: Icons.grid_view_rounded,
            color: Colors.deepPurple,
            tooltip: 'Projects',
            onTap: () => AppLauncherService.launch(context, AppType.projects),
          ),
          _DockItem(
            icon: Icons.folder,
            color: Colors.amber,
            tooltip: 'Files',
            onTap: () => AppLauncherService.launch(context, AppType.files),
          ),
          _DockItem(
            icon: Icons.terminal,
            color: Colors.black87,
            tooltip: 'Terminal',
            onTap: () => AppLauncherService.launch(context, AppType.terminal),
          ),
          _DockItem(
            icon: Icons.mail,
            color: Colors.blueAccent,
            tooltip: 'Mail',
            onTap: () => AppLauncherService.launch(context, AppType.email),
          ),
          _DockItem(
            icon: Icons.settings,
            color: Colors.grey,
            tooltip: 'Settings',
            onTap: () => AppLauncherService.launch(context, AppType.settings),
          ),
          // Divider + running windows, mirroring the real macOS dock.
          Container(
            width: 1,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const WindowTaskStrip(),
        ],
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _DockItem({
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
          child: Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
