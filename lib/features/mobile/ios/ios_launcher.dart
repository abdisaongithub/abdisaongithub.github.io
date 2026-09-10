import 'package:flutter/material.dart';
import '../../../core/live_clock.dart';
import '../../apps/app_enums.dart';
import '../../guide/guide_anchor.dart';
import '../../guide/guide_cubit.dart';
import '../../apps/app_launcher_service.dart';
import '../../apps/now_playing/now_playing_widget.dart';
import '../../desktop/desktop_wallpaper.dart';

class IosLauncher extends StatelessWidget {
  const IosLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Wallpaper
          const Positioned.fill(child: DesktopWallpaper()),

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
            // Shrink-wrapped so the guide rings the icons, not the empty
            // screen beneath them.
            child: Align(
              alignment: Alignment.topCenter,
              child: GuideAnchor(
                target: GuideTarget.apps,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  childAspectRatio: 0.75, // Matches the fix for Android
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  children: [
                    _IosAppIcon(
                        label: 'FaceTime',
                        icon: Icons.videocam,
                        color: Colors.green,
                        onTap: () =>
                            AppLauncherService.launch(context, AppType.camera)),
                    GuideAnchor(
                      target: GuideTarget.terminal,
                      child: _IosAppIcon(
                          label: 'Terminal',
                          icon: Icons.terminal,
                          color: Colors.black87,
                          onTap: () => AppLauncherService.launch(
                              context, AppType.terminal)),
                    ),
                    _IosAppIcon(
                        label: 'GitHub',
                        icon: Icons.code,
                        color: Colors.black87,
                        onTap: () =>
                            AppLauncherService.launch(context, AppType.github)),
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
                        onTap: () => AppLauncherService.launch(
                            context, AppType.projects)),
                    _IosAppIcon(
                        label: 'Settings',
                        icon: Icons.settings,
                        color: Colors.grey,
                        onTap: () => AppLauncherService.launch(
                            context, AppType.settings)),
                  ],
                ),
              ),
            ),
          ),

          // Dock
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: const _IosDock(),
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
      padding: EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LiveClock(
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              height: 1.0,
            ),
          ),
          Row(
            children: [
              NowPlayingWidget(variant: NowPlayingVariant.indicator),
              SizedBox(width: 6),
              Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 15),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 15),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.white, size: 15),
            ],
          ),
        ],
      ),
    );
  }
}

class _IosDock extends StatelessWidget {
  const _IosDock();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
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
                onTap: () =>
                    AppLauncherService.launch(context, AppType.github)),
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
  final bool isDock;
  final VoidCallback onTap;

  const _IosAppIcon({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
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
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(
              icon,
              color: color == Colors.white ? Colors.blue : Colors.white,
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
