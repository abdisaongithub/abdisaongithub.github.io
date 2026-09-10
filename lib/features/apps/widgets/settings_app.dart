import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../os_mode/cubit/os_mode_cubit.dart';
import '../../os_mode/os_mode.dart';
import '../../theme/theme_cubit.dart';

class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.grey[100],
            child: ListView(
              children: const [
                _SidebarItem(
                  icon: Icons.monitor,
                  title: 'Personalization',
                  isSelected: true,
                ),
                _SidebarItem(icon: Icons.system_update, title: 'System'),
                _SidebarItem(icon: Icons.bluetooth, title: 'Bluetooth'),
                _SidebarItem(icon: Icons.wifi, title: 'Network'),
                _SidebarItem(icon: Icons.person, title: 'Accounts'),
              ],
            ),
          ),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                const Text(
                  'Personalization',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select a background',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Backgrounds',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Driven by the same map the desktops use, so every tile here
                // points at an asset that actually ships with the app.
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final entry in kOSWallpapers.entries)
                      if (entry.value.isNotEmpty)
                        _WallpaperOption(
                          assetPath: entry.value,
                          label: _labelFor(entry.key),
                        ),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Appearance',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: state.isDarkMode,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                      title: const Text('Dark mode'),
                      subtitle: const Text(
                        'Applies to the web landing page and app chrome',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Operating system',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                BlocBuilder<OSModeCubit, OSModeState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final mode in OSMode.values)
                          ChoiceChip(
                            label: Text(_labelFor(mode)),
                            selected: state.mode == mode,
                            onSelected: (_) =>
                                context.read<OSModeCubit>().setMode(mode),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _labelFor(OSMode mode) {
    switch (mode) {
      case OSMode.windows:
        return 'Windows';
      case OSMode.macos:
        return 'macOS';
      case OSMode.linux:
        return 'Ubuntu';
      case OSMode.android:
        return 'Android';
      case OSMode.ios:
        return 'iOS';
      case OSMode.web:
        return 'Web';
    }
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
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _WallpaperOption extends StatelessWidget {
  final String assetPath;
  final String label;

  const _WallpaperOption({required this.assetPath, required this.label});

  @override
  Widget build(BuildContext context) {
    final isSelected = context.select<ThemeCubit, bool>(
      (cubit) => cubit.state.wallpaper == assetPath,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<ThemeCubit>().setWallpaper(assetPath),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 80,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                color: Colors.grey,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(color: Colors.grey),
                  ),
                  if (isSelected)
                    const Center(
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
