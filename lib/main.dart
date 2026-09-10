import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/design/tokens.dart';
import 'features/apps/now_playing/now_playing_cubit.dart';
import 'features/apps/github/github_cubit.dart';
import 'features/apps/services/github_service.dart';
import 'features/command/command_palette.dart';
import 'features/file_system/cubit/file_system_cubit.dart';
import 'features/os_mode/cubit/os_mode_cubit.dart';
import 'features/speedrun/speedrun_cubit.dart';
import 'features/theme/theme_cubit.dart';
import 'features/virtual_window/cubit/window_manager_cubit.dart';
import 'main_orchestrator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => GithubService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => OSModeCubit()),
          BlocProvider(create: (_) => WindowManagerCubit()),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => FileSystemCubit()),
          // One shared playback state for every surface that shows now-playing.
          BlocProvider(create: (_) => NowPlayingCubit()),
          BlocProvider(create: (context) => GithubCubit(context.read())),
          BlocProvider(
            create: (context) => SpeedrunCubit(
              windows: context.read<WindowManagerCubit>(),
              osMode: context.read<OSModeCubit>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Abdisa Tsegaye — Portfolio',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(),
          home:
              const _AppShortcuts(child: _FirstRun(child: MainOrchestrator())),
        ),
      ),
    );
  }

  static ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
        surface: AppColors.surface,
      ),
      textTheme: Typography.whiteMountainView.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceOverlay,
          borderRadius: AppRadius.allSm,
          border: Border.all(color: AppColors.border),
        ),
        textStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 12,
        ),
        waitDuration: const Duration(milliseconds: 400),
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}

/// Offers the guided tour a beat after the landing page settles.
///
/// Nothing is opened automatically and nothing is forced: the landing page is
/// already the content, and the tour is an invitation to see the OS.
class _FirstRun extends StatefulWidget {
  final Widget child;

  const _FirstRun({required this.child});

  @override
  State<_FirstRun> createState() => _FirstRunState();
}

class _FirstRunState extends State<_FirstRun> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    // Long enough that it reads as an offer rather than an interruption.
    await Future<void>.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    context.read<SpeedrunCubit>().offer();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// App-wide keyboard shortcuts. Ctrl/Cmd-K opens the command palette from
/// anywhere, including inside the OS shells.
class _AppShortcuts extends StatelessWidget {
  final Widget child;

  const _AppShortcuts({required this.child});

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            CommandPalette.show(context),
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
            CommandPalette.show(context),
      },
      child: Focus(autofocus: true, child: child),
    );
  }
}
