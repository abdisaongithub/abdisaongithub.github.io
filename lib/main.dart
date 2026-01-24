import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// If desktop
import 'main_orchestrator.dart';
import 'features/os_mode/cubit/os_mode_cubit.dart';
import 'features/virtual_window/cubit/window_manager_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // await dotenv.load(fileName: ".env");
  } catch (e) {
    // Silent catch for prototype
  }

  // Initialize window manager for actual desktop window behavior (optional)
  // await windowManager.ensureInitialized();

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
      ],
      child: const MaterialApp(
        title: 'Abdisa Portfolio',
        debugShowCheckedModeBanner: false,
        home: MainOrchestrator(),
      ),
    );
  }
}
