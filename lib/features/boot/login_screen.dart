import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/profile.dart';
import '../os_mode/cubit/os_mode_cubit.dart';
import '../theme/theme_cubit.dart';
import '../../main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _login(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainSystem(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OSModeCubit, OSModeState>(
      builder: (context, state) {
        // Wallpapers come from the same map the desktops use, instead of a
        // private copy that pointed at a `linux_wallpaper.jpg` that never
        // existed.
        final wallpaper = kOSWallpapers[state.mode] ?? '';

        return Scaffold(
          backgroundColor: const Color(0xFF0B0B14),
          body: Stack(
            fit: StackFit.expand,
            children: [
              if (wallpaper.isNotEmpty)
                Image.asset(
                  wallpaper,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              // Slight tint
              ColoredBox(color: Colors.black.withValues(alpha: 0.25)),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _Avatar(),
                    const SizedBox(height: 16),
                    const Text(
                      Profile.name,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      Profile.tagline,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    const fallback = Icon(Icons.person, size: 60, color: Colors.white70);

    return Container(
      width: 120,
      height: 120,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(color: Colors.white, width: 2),
      ),
      // Sourced from GitHub rather than a bundled `profile.jpg` that was
      // referenced but never committed.
      child: CachedNetworkImage(
        imageUrl: Profile.avatarUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(child: fallback),
        errorWidget: (context, url, error) => const Center(child: fallback),
      ),
    );
  }
}
