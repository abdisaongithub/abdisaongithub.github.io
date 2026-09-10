import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web/web.dart' as web;

import '../../core/design/tokens.dart';
import '../apps/app_enums.dart';
import '../apps/app_launcher_service.dart';
import '../desktop/linux/linux_desktop.dart';
import '../desktop/mac/mac_desktop.dart';
import '../desktop/windows/windows_desktop.dart';
import '../guide/guide_anchor.dart';
import '../guide/guide_cubit.dart';
import '../guide/guide_overlay.dart';
import '../guide/guide_steps.dart';
import '../mobile/android/android_launcher.dart';
import '../mobile/ios/ios_launcher.dart';
import '../os_mode/cubit/os_mode_cubit.dart';
import '../os_mode/os_mode.dart';
import '../switcher/os_switcher_widget.dart';

/// Everything that only exists inside an OS shell.
///
/// This library is loaded lazily (`deferred as`) from the orchestrator, so the
/// five desktop shells, the window manager UI and every windowed app stay out
/// of the initial JavaScript payload. A visitor who never opens the OS never
/// downloads it.
class OSSurface extends StatefulWidget {
  final OSModeState state;

  const OSSurface({super.key, required this.state});

  @override
  State<OSSurface> createState() => _OSSurfaceState();

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

class _OSSurfaceState extends State<OSSurface> {
  Timer? _firstVisit;

  @override
  void initState() {
    super.initState();
    // A beat after the shell fades in, so the visitor sees the desktop before
    // anything is pointed out. Only ever shown once, never re-offered.
    _firstVisit = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      final os = context.read<OSModeCubit>().state;
      context.read<GuideCubit>().showOSGuideOnce(
            () => GuideAnchors.available(
              osGuideSteps(os.mode, isHandset: os.isHandset),
            ),
          );
    });
  }

  @override
  void dispose() {
    _firstVisit?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final showsFrame = state.showsPhoneFrame;

    return Scaffold(
      body: Stack(
        children: [
          if (showsFrame)
            _MobileSimulator(mode: state.mode)
          else
            OSSurface.buildShell(state.mode),

          // Leave / guide / fullscreen, clear of each shell's top chrome.
          if (!state.isHandset)
            Positioned(
              top: OSSurface._topInsetFor(state.mode, showsFrame),
              right: 20,
              child: const Row(
                children: [
                  GuideAnchor(
                    target: GuideTarget.portfolio,
                    child: _BackToPortfolioButton(),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  _GuideButton(),
                  SizedBox(width: AppSpacing.sm),
                  _FullScreenToggle(),
                ],
              ),
            ),

          // Below the switcher, so its menu opens above the guide card rather
          // than underneath it.
          const GuideOverlay(),

          OSSwitcherWidget(
            bottomInset: OSSurface._switcherInsetFor(state.mode, showsFrame),
            onShowGuide: () => showOSGuide(context),
          ),
        ],
      ),
    );
  }
}

/// Opens the guide for the shell on screen, skipping controls it lacks.
void showOSGuide(BuildContext context) {
  final os = context.read<OSModeCubit>().state;
  context.read<GuideCubit>().open(
        GuideAnchors.available(osGuideSteps(os.mode, isHandset: os.isHandset)),
      );
}

/// Without this the OS is a one-way door — there was no way back to the
/// portfolio once you entered.
class _BackToPortfolioButton extends StatelessWidget {
  const _BackToPortfolioButton();

  @override
  Widget build(BuildContext context) {
    return _GlassButton(
      icon: Icons.arrow_back_rounded,
      tooltip: 'Back to portfolio',
      onTap: () => context.read<OSModeCubit>().exitToLanding(),
    );
  }
}

/// Reopens the guide on demand, so it is not a one-shot a visitor can miss.
class _GuideButton extends StatelessWidget {
  const _GuideButton();

  @override
  Widget build(BuildContext context) {
    return _GlassButton(
      icon: Icons.question_mark_rounded,
      tooltip: 'What can I do here?',
      onTap: () => showOSGuide(context),
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
                        OSSurface.buildShell(mode),
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

/// Opens the portfolio window from inside a shell.
void openPortfolioWindow(BuildContext context) {
  AppLauncherService.launch(context, AppType.portfolio);
}
