import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_cubit.dart';

class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Available wallpapers (using placeholders or assuming assets exist)
    // Ideally these would be real assets. For now we reuse the main one or colors.
    final wallpapers = [
      'assets/images/windows_wallpaper.jpg',
      'assets/images/macos_wallpaper.jpg', // You might need to add this asset or use a color
      'assets/images/linux_wallpaper.jpg', // And this
      'assets/images/abstract.jpg', // Placeholder
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.grey[100],
            child: ListView(
              children: [
                _SidebarItem(
                    icon: Icons.monitor,
                    title: 'Personalization',
                    isSelected: true),
                _SidebarItem(icon: Icons.system_update, title: 'System'),
                _SidebarItem(icon: Icons.bluetooth, title: 'Bluetooth'),
                _SidebarItem(icon: Icons.wifi, title: 'Network'),
                _SidebarItem(icon: Icons.person, title: 'Accounts'),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Personalization',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Select a background',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),

                  // Wallpaper Grid
                  Text('Recent Images',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: wallpapers
                        .map((path) => _WallpaperOption(path))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.white : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
        title: Text(title,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}

class _WallpaperOption extends StatelessWidget {
  final String assetPath;

  const _WallpaperOption(this.assetPath);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ThemeCubit>().setWallpaper(assetPath);
      },
      child: Column(
        children: [
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
              image: DecorationImage(
                image: AssetImage(assetPath),
                fit: BoxFit.cover,
                // Fallback for missing assets
                onError: (exception, stackTrace) {},
              ),
              color: Colors.grey, // Fallback color
            ),
            child: context.watch<ThemeCubit>().state.wallpaper == assetPath
                ? Center(
                    child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                    child: Icon(Icons.check, color: Colors.white, size: 16),
                  ))
                : null,
          ),
          const SizedBox(height: 4),
          const Text('Background', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
