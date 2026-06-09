import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../virtual_window/cubit/window_manager_cubit.dart';
import '../../virtual_window/window_content.dart';
import '../../virtual_window/virtual_window_widget.dart';
import '../../virtual_window/window_content_builder.dart';
import '../../virtual_window/base_window_frame.dart';
import '../../apps/app_enums.dart';
import '../../apps/app_launcher_service.dart';
import '../../apps/widgets/spotify_widget.dart';

class MacDesktop extends StatelessWidget {
  const MacDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        fontFamily: '.SF Pro Text', // Attempt Mac font
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Wallpaper
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/macos_wallpaper.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Top Menu Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 24,
              child: _MacMenuBar(),
            ),

            // Dock
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(child: _MacDock()),
            ),

            // Window Manager
            const _MacWindowManager(),
          ],
        ),
      ),
    );
  }
}

class _MacMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.apple, color: Colors.white, size: 16),
          SizedBox(width: 16),
          Text('Finder',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          SizedBox(width: 16),
          Text('File', style: TextStyle(color: Colors.white, fontSize: 13)),
          SizedBox(width: 12),
          Text('Edit', style: TextStyle(color: Colors.white, fontSize: 13)),
          Spacer(),
          SpotifyWidget(),
          SizedBox(width: 16),
          Icon(Icons.wifi, color: Colors.white, size: 14),
          SizedBox(width: 12),
          Text('9:41 AM', style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

class _MacDock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DockItem(
            icon: Icons.face,
            color: Colors.blue,
            onTap: () => AppLauncherService.launch(context, AppType.cv),
          ),
          _DockItem(
            icon: Icons.mail,
            color: Colors.white,
            onTap: () => AppLauncherService.launch(context, AppType.email),
          ),
          _DockItem(
            icon: Icons.camera_alt,
            color: Colors.grey,
            onTap: () => AppLauncherService.launch(context, AppType.camera),
          ),
          _DockItem(
            icon: Icons.music_note,
            color: Colors.pinkAccent,
            onTap: () => AppLauncherService.launch(context, AppType.projects),
          ),
          _DockItem(
            icon: Icons.settings,
            color: Colors.grey,
            onTap: () => AppLauncherService.launch(context, AppType.settings),
          ),
        ],
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

class _MacWindowManager extends StatelessWidget {
  const _MacWindowManager();

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
                    return BaseWindowFrame(
                      title: title,
                      onClose: close,
                      onMinimize: minimize,
                      onMaximize: maximize,
                      style: WindowButtonStyle.mac,
                    );
                  },
                  child: WindowContentBuilder(content: window.content),
                );
              })
              .toList()
              .cast<Widget>(),
        );
      },
    );
  }
}
