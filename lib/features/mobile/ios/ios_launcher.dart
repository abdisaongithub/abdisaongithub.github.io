import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../apps/app_enums.dart';
import '../../apps/app_launcher_service.dart';
import '../../theme/theme_cubit.dart';

class IosLauncher extends StatelessWidget {
  const IosLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Wallpaper
          Positioned.fill(
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(state.wallpaper),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),

          // Status Bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 44,
            child: _IosStatusBar(),
          ),

          // App Grid
          Positioned.fill(
            top: 60,
            bottom: 100,
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 0.75, // Matches the fix for Android
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              children: [
                _IosAppIcon(
                    label: 'FaceTime',
                    icon: Icons.videocam,
                    color: Colors.green,
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.camera)),
                _IosAppIcon(
                    label: 'Calendar',
                    icon: Icons.calendar_today,
                    color: Colors.white,
                    iconColor: Colors.red,
                    onTap: () {}), // No calendar app yet
                _IosAppIcon(
                    label: 'Photos',
                    icon: Icons.photo_library,
                    color: Colors.white,
                    iconColor: Colors.orange,
                    onTap: () {}), // No photos app yet
                _IosAppIcon(
                    label: 'Camera',
                    icon: Icons.camera_alt,
                    color: Colors.grey,
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.camera)),
                _IosAppIcon(
                    label: 'Mail',
                    icon: Icons.email,
                    color: Colors.blue,
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.email)),
                _IosAppIcon(
                    label: 'Projects',
                    icon: Icons.folder_open,
                    color: Colors.yellow,
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.projects)),
                _IosAppIcon(
                    label: 'Settings',
                    icon: Icons.settings,
                    color: Colors.grey,
                    onTap: () =>
                        AppLauncherService.launch(context, AppType.settings)),
              ],
            ),
          ),

          // Dock
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _IosDock(),
          ),
        ],
      ),
    );
  }
}

class _IosStatusBar extends StatelessWidget {
  const _IosStatusBar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('9:41',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.white, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _IosDock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _IosAppIcon(
                label: '',
                icon: Icons.phone,
                color: Colors.green,
                isDock: true,
                onTap: () => AppLauncherService.launch(context, AppType.phone)),
            _IosAppIcon(
                label: '',
                icon: Icons.language,
                color: Colors.blue,
                isDock: true,
                onTap: () =>
                    AppLauncherService.launch(context, AppType.browser)),
            _IosAppIcon(
                label: '',
                icon: Icons.chat_bubble,
                color: Colors.green,
                isDock: true,
                onTap: () => AppLauncherService.launch(
                    context, AppType.email)), // SMS/Chat placeholder
            _IosAppIcon(
                label: '',
                icon: Icons.music_note,
                color: Colors.pink,
                isDock: true,
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _IosAppIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final dynamic iconColor; // Can be Color or "multicolor"
  final bool isDock;
  final VoidCallback onTap;

  const _IosAppIcon({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.iconColor,
    this.isDock = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isDock ? 60 : 64,
            height: isDock ? 60 : 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isDock)
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor is Color
                  ? iconColor
                  : (color == Colors.white ? Colors.blue : Colors.white),
              size: isDock ? 32 : 36,
            ),
          ),
          if (!isDock) ...[
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ],
      ),
    );
  }
}
