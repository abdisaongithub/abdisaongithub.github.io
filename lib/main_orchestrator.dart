import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/os_mode/cubit/os_mode_cubit.dart';
import 'features/os_mode/os_mode.dart';
import 'features/desktop/windows/windows_desktop.dart';
import 'features/desktop/mac/mac_desktop.dart';
import 'features/desktop/linux/linux_desktop.dart';
import 'features/mobile/android/android_launcher.dart';
import 'features/mobile/ios/ios_launcher.dart';
import 'features/switcher/os_switcher_widget.dart';

class MainOrchestrator extends StatelessWidget {
  const MainOrchestrator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OSModeCubit, OSModeState>(
      builder: (context, state) {
        // Note: For now Android and iOS are the ones we'll force simulate.
        final shouldSimulateMobile =
            state.mode == OSMode.android || state.mode == OSMode.ios;

        return Scaffold(
          body: Stack(
            children: [
              // 1. The active OS Content
              if (shouldSimulateMobile)
                _buildMobileSimulator(context, state.mode)
              else
                _buildBGLayer(state.mode),

              // 2. Full Screen Toggle (Top Right)
              Positioned(
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
  }

  Widget _buildMobileSimulator(BuildContext context, OSMode mode) {
    return Container(
      color: const Color(0xFF0F0F0F), // Sleek deep background
      child: Center(
        child: Container(
          width: 360,
          height: 780,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(48), // Smoother premium corners
            border:
                Border.all(color: const Color(0xFF1F1F1F), width: 12), // Bezel
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              _buildBGLayer(mode),
              // The Notch
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.top(8),
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
        return const Center(
          child: Text(
            "Web Mode (Coming Soon)",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
    }
  }
}

class _FullScreenToggle extends StatefulWidget {
  @override
  State<_FullScreenToggle> createState() => _FullScreenToggleState();
}

class _FullScreenToggleState extends State<_FullScreenToggle> {
  bool _isFullScreen = false;

  void _toggleFullScreen() {
    setState(() => _isFullScreen = !_isFullScreen);
    // In a real web app, we'd use dart:html document.documentElement.requestFullscreen()
    // For this prototype, we'll just toggle the icon to show we're "handling" it.
    // print("Toggle FullScreen: $_isFullScreen");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: _toggleFullScreen,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
