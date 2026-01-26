import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile_number/mobile_number.dart'; // Maybe useful for sim details, but simplified for now
import '../../os_mode/cubit/os_mode_cubit.dart';
import '../../os_mode/os_mode.dart';
import '../../apps/app_enums.dart';
import '../../apps/app_launcher_service.dart';

class AndroidLauncher extends StatelessWidget {
  const AndroidLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark mode default
      body: Stack(
        children: [
          // Wallpaper
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Status Bar (Fake)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 24,
            child: _AndroidStatusBar(),
          ),

          // App Grid
          Positioned.fill(
            top: 40,
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 0.8, // More vertical space for labels
              padding: const EdgeInsets.all(16),
              children: [
                _AppIcon(
                  label: 'About',
                  icon: Icons.person,
                  color: Colors.blue,
                  onTap: () => AppLauncherService.launch(context, AppType.cv),
                ),
                _AppIcon(
                  label: 'Projects',
                  icon: Icons.folder,
                  color: Colors.amber,
                  onTap: () =>
                      AppLauncherService.launch(context, AppType.projects),
                ),
                _AppIcon(
                  label: 'Skills',
                  icon: Icons.bolt,
                  color: Colors.yellow,
                  // TODO: Add Skills app type or modal
                  onTap: () {},
                ),
                _AppIcon(
                  label: 'Contact',
                  icon: Icons.email,
                  color: Colors.red,
                  onTap: () =>
                      AppLauncherService.launch(context, AppType.email),
                ),
                _AppIcon(
                  label: 'Settings',
                  icon: Icons.settings,
                  color: Colors.grey,
                  onTap: () =>
                      AppLauncherService.launch(context, AppType.settings),
                ),
              ],
            ),
          ),

          // Navigation Bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 48,
            child: _AndroidNavBar(),
          ),
        ],
      ),
    );
  }
}

class _AndroidStatusBar extends StatelessWidget {
  const _AndroidStatusBar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.wifi, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Icon(Icons.battery_full, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text('12:00', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

class _AndroidNavBar extends StatelessWidget {
  const _AndroidNavBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.circle_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.square_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _AppIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AppIcon({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
