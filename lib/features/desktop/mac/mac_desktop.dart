import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../virtual_window/cubit/window_manager_cubit.dart';
import '../../virtual_window/virtual_window_widget.dart';

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
                    image: AssetImage(
                        'assets/images/ios_wallpaper.jpg'), // Using provided mac/ios wallpaper
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
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DockItem(icon: Icons.face, color: Colors.blue),
          _DockItem(icon: Icons.mail, color: Colors.white),
          _DockItem(icon: Icons.camera_alt, color: Colors.grey),
          _DockItem(icon: Icons.music_note, color: Colors.pinkAccent),
          _DockItem(icon: Icons.settings, color: Colors.grey),
        ],
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _DockItem({required this.icon, required this.color});

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
      child: Icon(icon, color: Colors.white, size: 28),
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
                    return Container(
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBEBEB),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          _MacStoplight(color: Colors.red, onTap: close),
                          const SizedBox(width: 8),
                          _MacStoplight(color: Colors.orange, onTap: minimize),
                          const SizedBox(width: 8),
                          _MacStoplight(color: Colors.green, onTap: maximize),
                          const Spacer(),
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          const SizedBox(width: 60), // Balance the stoplights
                        ],
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    child: Center(
                        child: Text("App Content: ${window.content.title}")),
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

class _MacStoplight extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  const _MacStoplight({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
