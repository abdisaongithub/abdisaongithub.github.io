
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import 'landing/landing_screen.dart';
import 'theme/theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final apiClient = GetIt.I<ApiClient>();
    // final credentialStorage = GetIt.I<SecureCredentialsStorage>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          // debugPrint('OS: ${Platform.operatingSystem}'.toString());

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state == const ThemeState.dark() ? ThemeMode.dark : ThemeMode.light,
            theme: context.read<ThemeCubit>().getLightMode(),
            darkTheme: context.read<ThemeCubit>().getDarkMode(),
            initialRoute: '/',
            routes: {
              '/': (context) => const LandingScreen(),
            },
          );
        },
      ),
    );
  }
}
