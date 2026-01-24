import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../virtual_window/cubit/window_manager_cubit.dart';
import '../../virtual_window/virtual_window_widget.dart';

class LinuxDesktop extends StatelessWidget {
  const LinuxDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF300A24), // Ubuntu purple
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Ubuntu Gradient Wallpaper
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE95420), Color(0xFF300A24)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),

            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 28,
              child: _UbuntuTopBar(),
            ),

            // Side Dock
            Positioned(
              top: 28,
              left: 0,
              bottom: 0,
              width: 48,
              child: _UbuntuDock(),
            ),

            // Window Manager
            const _LinuxWindowManager(),
          ],
        ),
      ),
    );
  }
}

class _UbuntuTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: const Row(
        children: [
          Text('Activities',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),
          Spacer(),
          Text('Jan 25 01:28 AM',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Column(
        children: [
          _DockAppIcon(icon: Icons.grid_view, color: Colors.white),
          const SizedBox(height: 12),
          _DockAppIcon(icon: Icons.folder, color: Colors.orange),
          _DockAppIcon(icon: Icons.language, color: Colors.orange),
          _DockAppIcon(icon: Icons.settings, color: Colors.grey),
          const Spacer(),
          _DockAppIcon(icon: Icons.apps, color: Colors.white),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DockAppIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _DockAppIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

class _LinuxWindowManager extends StatelessWidget {
  const _LinuxWindowManager();

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
                    return Container(
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3E3E3E), // Ubuntu window header
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          Text(title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          const Spacer(),
                          _UbuntuWindowBtn(icon: Icons.remove, onTap: minimize),
                          _UbuntuWindowBtn(
                              icon: Icons.crop_square, onTap: maximize),
                          _UbuntuWindowBtn(
                              icon: Icons.close, onTap: close, isClose: true),
                          const SizedBox(width: 4),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    color: const Color(0xFFF2F1F0),
                    child: Center(
                        child: Text("Linux Content: ${window.content.title}",
                            style: const TextStyle(color: Colors.black))),
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

class _UbuntuWindowBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;
  const _UbuntuWindowBtn(
      {required this.icon, required this.onTap, this.isClose = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color:
              isClose ? const Color(0xFFE95420) : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}
