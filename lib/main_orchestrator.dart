import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web/web.dart' as web;

import 'core/design/tokens.dart';
import 'features/apps/app_enums.dart';
import 'features/apps/app_launcher_service.dart';
import 'features/boot/boot_screen.dart';
import 'features/desktop/linux/linux_desktop.dart';
import 'features/desktop/mac/mac_desktop.dart';
import 'features/desktop/windows/windows_desktop.dart';
import 'features/mobile/android/android_launcher.dart';
import 'features/mobile/ios/ios_launcher.dart';
import 'features/os_mode/cubit/os_mode_cubit.dart';
import 'features/os_mode/os_mode.dart';
import 'features/speedrun/speedrun_cubit.dart';
import 'features/speedrun/speedrun_overlay.dart';
import 'features/switcher/os_switcher_widget.dart';
import 'features/theme/theme_cubit.dart';

/// Boots straight into the visitor's own platform, then renders that shell.
///
/// The portfolio lives inside as a window, opened automatically on arrival so
/// the work is on screen within a second rather than something to go hunting
/// for. The speedrun is offered alongside it.
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
          return AnimatedSwitcher(
            duration: AppMotion.normal,
            child: _surfaceFor(context, state),
          );
        },
      ),
    );
  }

  Widget _surfaceFor(BuildContext context, OSModeState state) {
    if (state.isBooting) {
      return BootScreen(
        key: const ValueKey('boot'),
        mode: state.mode,
        onComplete: () => context.read<OSModeCubit>().bootComplete(),
      );
    }

    return OSShell(key: ValueKey('os-${state.mode}'), state: state);
  }
}

class OSShell extends StatelessWidget {
  final OSModeState state;

  const OSShell({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final showsFrame = state.showsPhoneFrame;

    return Scaffold(
      body: Stack(
        children: [
          if (showsFrame)
            _MobileSimulator(mode: state.mode)
          else
            buildShell(state.mode),

          // Leave / fullscreen controls, clear of each shell's top chrome.
          if (!state.isHandset)
            Positioned(
              top: _topInsetFor(state.mode, showsFrame),
              right: 20,
              child: const Row(
                children: [
                  _ExitToPortfolioButton(),
                  SizedBox(width: AppSpacing.sm),
                  _ReplayTourButton(),
                  SizedBox(width: AppSpacing.sm),
                  _FullScreenToggle(),
                ],
              ),
            ),

          OSSwitcherWidget(
            bottomInset: _switcherInsetFor(state.mode, showsFrame),
          ),

          // Above the shell chrome so it survives an OS switch mid-tour.
          const SpeedrunOverlay(),
        ],
      ),
    );
  }

  static Widget buildShell(OSMode mode) {
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
    }
  }

  /// Bottom chrome each shell occupies, so the floating switcher never covers
  /// the taskbar, dock or navigation bar.
  static double _switcherInsetFor(OSMode mode, bool showsFrame) {
    // Inside the simulator the shell's own chrome is within the phone frame,
    // so the switcher only has to clear the page itself.
    if (showsFrame) return 24;

    switch (mode) {
      case OSMode.windows:
        return 60; // 48px taskbar
      case OSMode.macos:
        return 96; // 88px reserved for the dock
      case OSMode.android:
        return 60; // 48px navigation bar
      case OSMode.ios:
        return 116; // 84px dock, offset 20 from the bottom
      case OSMode.linux:
        return 24; // dock is on the left edge
    }
  }

  /// macOS and Ubuntu both own the top strip of the screen.
  static double _topInsetFor(OSMode mode, bool showsFrame) {
    if (showsFrame) return 24;
    switch (mode) {
      case OSMode.macos:
        return 36;
      case OSMode.linux:
        return 40;
      case OSMode.windows:
      case OSMode.android:
      case OSMode.ios:
        return 24;
    }
  }
}

/// Without this the OS shells are a one-way door — there was no way back to
/// the portfolio once you entered one.
class _ExitToPortfolioButton extends StatelessWidget {
  const _ExitToPortfolioButton();

  @override
  Widget build(BuildContext context) {
    return _GlassButton(
      icon: Icons.auto_awesome_mosaic_outlined,
      tooltip: 'Open portfolio',
      onTap: () => AppLauncherService.launch(context, AppType.portfolio),
    );
  }
}

/// Replays the tour on demand, so it is not a one-shot a visitor can miss.
class _ReplayTourButton extends StatelessWidget {
  const _ReplayTourButton();

  @override
  Widget build(BuildContext context) {
    return _GlassButton(
      icon: Icons.play_circle_outline_rounded,
      tooltip: 'Watch the 30s tour',
      onTap: () => context.read<SpeedrunCubit>().start(),
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
    return _GlassButton(
      icon: _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
      tooltip: _isFullScreen ? 'Exit full screen' : 'Full screen',
      onTap: _toggleFullScreen,
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _GlassButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: ClipRRect(
        borderRadius: AppRadius.pill,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: AppRadius.pill,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileSimulator extends StatelessWidget {
  final OSMode mode;

  const _MobileSimulator({required this.mode});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
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
                        OSShell.buildShell(mode),
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
