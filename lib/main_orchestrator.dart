import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web/web.dart' as web;

import 'features/os_mode/cubit/os_mode_cubit.dart';
import 'features/os_mode/os_mode.dart';
import 'features/desktop/windows/windows_desktop.dart';
import 'features/desktop/mac/mac_desktop.dart';
import 'features/desktop/linux/linux_desktop.dart';
import 'features/mobile/android/android_launcher.dart';
import 'features/mobile/ios/ios_launcher.dart';
import 'features/web/web_launcher.dart';
import 'features/switcher/os_switcher_widget.dart';
import 'features/theme/theme_cubit.dart';

class MainOrchestrator extends StatelessWidget {
  const MainOrchestrator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OSModeCubit, OSModeState>(
      listenWhen: (previous, current) => previous.mode != current.mode,
      listener: (context, state) {
        context.read<ThemeCubit>().setWallpaperForOS(state.mode);
      },
      child: BlocBuilder<OSModeCubit, OSModeState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isPortrait = constraints.maxHeight > constraints.maxWidth;
              final isMobileMode =
                  state.mode == OSMode.android || state.mode == OSMode.ios;

              // Enforce simulation if:
              // 1. It's a mobile mode AND user manually selected it.
              // 2. OR it's a mobile mode AND we are in Landscape.
              final shouldShowSimulator =
                  isMobileMode && (state.isManual || !isPortrait);

              return Scaffold(
                body: Stack(
                  children: [
                    // 1. The active OS Content
                    if (shouldShowSimulator)
                      _MobileSimulator(mode: state.mode)
                    else
                      _buildBGLayer(state.mode),

                    // 2. Full Screen Toggle (Top Right)
                    if (!isPortrait)
                      const Positioned(
                        top: 40,
                        right: 20,
                        child: _FullScreenToggle(),
                      ),

                    // 3. The Global Switcher
                    const OSSwitcherWidget(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBGLayer(OSMode mode) {
    switch (mode) {
      case OSMode.windows:
        return const WindowsDesktop();
      case OSMode.macos:
        return const MacDesktop();
      case OSMode.linux:
        return const LinuxDesktop();
      case OSMode.android:
        return const AndroidLauncher();
      case OSMode.ios:
        return const IosLauncher();
      case OSMode.web:
        return const WebLauncher();
    }
  }
}

class _MobileSimulator extends StatelessWidget {
  final OSMode mode;

  const _MobileSimulator({required this.mode});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0F0F0F),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Scale the handset down on short viewports so the frame is never
            // taller than the window it sits in.
            const baseWidth = 360.0;
            const baseHeight = 780.0;
            final scale = ((constraints.maxHeight - 48) / baseHeight).clamp(
              0.5,
              1.0,
            );

            return SizedBox(
              width: baseWidth * scale,
              height: baseHeight * scale,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: baseWidth,
                  height: baseHeight,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(48),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      border: Border.all(
                        color: const Color(0xFF1F1F1F),
                        width: 12,
                      ),
                    ),
                    child: Stack(
                      children: [
                        mode == OSMode.android
                            ? const AndroidLauncher()
                            : const IosLauncher(),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 120,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FullScreenToggle extends StatefulWidget {
  const _FullScreenToggle();

  @override
  State<_FullScreenToggle> createState() => _FullScreenToggleState();
}

class _FullScreenToggleState extends State<_FullScreenToggle> {
  bool _isFullScreen = false;

  // Uses package:web; dart:html is deprecated and made the app un-compilable
  // for any non-web target.
  void _toggleFullScreen() {
    try {
      if (_isFullScreen) {
        web.document.exitFullscreen();
      } else {
        web.document.documentElement?.requestFullscreen();
      }
      setState(() => _isFullScreen = !_isFullScreen);
    } catch (e) {
      debugPrint('Full screen error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _isFullScreen ? 'Exit full screen' : 'Full screen',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: InkWell(
            onTap: _toggleFullScreen,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(
                _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
