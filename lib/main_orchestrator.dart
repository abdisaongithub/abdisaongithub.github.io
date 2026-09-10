import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/design/tokens.dart';
import 'features/boot/boot_screen.dart';
import 'features/guide/guide_cubit.dart';
import 'features/landing/landing_page.dart';
import 'features/os_mode/cubit/os_mode_cubit.dart';
import 'features/theme/theme_cubit.dart';

// Loaded on demand. The five shells, the window-manager UI and every windowed
// app live behind this, so a visitor who never opens the OS never downloads
// that JavaScript.
import 'features/os/os_surface.dart' deferred as os_surface;

/// Routes between the landing page and the OS shells.
///
/// The landing page is the entry point: it is the fast, content-first surface
/// a recruiter needs. Entering the OS is explicit, and the BIOS animation
/// covers the deferred bundle downloading.
class MainOrchestrator extends StatelessWidget {
  const MainOrchestrator({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OSModeCubit, OSModeState>(
          listenWhen: (previous, current) => previous.mode != current.mode,
          listener: (context, state) {
            context.read<ThemeCubit>().setWallpaperForOS(state.mode);
          },
        ),
        // The guide describes the shell on screen, so leaving it or switching
        // to another one ends the guide.
        BlocListener<OSModeCubit, OSModeState>(
          listenWhen: (previous, current) =>
              previous.mode != current.mode ||
              previous.isInOS != current.isInOS,
          listener: (context, _) => context.read<GuideCubit>().dismiss(),
        ),
      ],
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
    if (!state.isInOS) {
      return const LandingPage(key: ValueKey('landing'));
    }

    if (state.isBooting) {
      return _BootGate(key: ValueKey('boot-${state.mode}'), state: state);
    }

    return _LoadedOSSurface(key: ValueKey('os-${state.mode}'), state: state);
  }
}

/// Plays the boot animation while the deferred OS bundle downloads, and only
/// finishes once both are done — so the wait is the experience rather than a
/// blank screen.
class _BootGate extends StatefulWidget {
  final OSModeState state;

  const _BootGate({super.key, required this.state});

  @override
  State<_BootGate> createState() => _BootGateState();
}

class _BootGateState extends State<_BootGate> {
  bool _animationDone = false;
  bool _bundleReady = false;

  @override
  void initState() {
    super.initState();
    _loadBundle();
  }

  Future<void> _loadBundle() async {
    try {
      await os_surface.loadLibrary();
    } catch (e) {
      debugPrint('OS bundle failed to load: $e');
    }
    if (!mounted) return;
    setState(() => _bundleReady = true);
    _finishIfReady();
  }

  void _onAnimationComplete() {
    if (!mounted) return;
    setState(() => _animationDone = true);
    _finishIfReady();
  }

  void _finishIfReady() {
    if (_animationDone && _bundleReady && mounted) {
      context.read<OSModeCubit>().bootComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BootScreen(
      mode: widget.state.mode,
      onComplete: _onAnimationComplete,
    );
  }
}

/// The deferred library is guaranteed loaded by the time this builds.
class _LoadedOSSurface extends StatelessWidget {
  final OSModeState state;

  const _LoadedOSSurface({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return os_surface.OSSurface(state: state);
  }
}
