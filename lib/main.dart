import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/boot/boot_screen.dart';
import 'main_orchestrator.dart';
import 'features/os_mode/cubit/os_mode_cubit.dart';
import 'features/virtual_window/cubit/window_manager_cubit.dart';
import 'features/theme/theme_cubit.dart';
import 'features/file_system/cubit/file_system_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OSModeCubit()),
        BlocProvider(create: (_) => WindowManagerCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => FileSystemCubit()),
      ],
      child: const MaterialApp(
        title: 'Abdisa Portfolio',
        debugShowCheckedModeBanner: false,
        home: BootScreen(),
      ),
    );
  }
}

// The core OS system, accessed after login
class MainSystem extends StatelessWidget {
  const MainSystem({super.key});

  @override
  Widget build(BuildContext context) {
    // Blocs are now provided at the root, so we just return the Orchestrator
    return const MainOrchestrator();
  }
}
