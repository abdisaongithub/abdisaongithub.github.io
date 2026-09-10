import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/desktop/linux/linux_desktop.dart';
import 'package:flutter_portfolio_app/features/desktop/mac/mac_desktop.dart';
import 'package:flutter_portfolio_app/features/desktop/windows/windows_desktop.dart';
import 'package:flutter_portfolio_app/features/apps/now_playing/now_playing_cubit.dart';
import 'package:flutter_portfolio_app/features/apps/services/github_service.dart';
import 'package:flutter_portfolio_app/features/file_system/cubit/file_system_cubit.dart';
import 'package:flutter_portfolio_app/features/mobile/android/android_launcher.dart';
import 'package:flutter_portfolio_app/features/mobile/ios/ios_launcher.dart';
import 'package:flutter_portfolio_app/features/os_mode/cubit/os_mode_cubit.dart';
import 'package:flutter_portfolio_app/features/os_mode/os_mode.dart';
import 'package:flutter_portfolio_app/features/web/web_launcher.dart';
import 'package:flutter_portfolio_app/features/theme/theme_cubit.dart';
import 'package:flutter_portfolio_app/features/virtual_window/cubit/window_manager_cubit.dart';

import '../../support/test_harness.dart';

/// Every shell must lay out cleanly at both a desktop and a phone width.
///
/// The now-playing widget used to be a fixed 260x44 card dropped into the
/// macOS menu bar (24px) and the Ubuntu top bar (28px), which overflowed on
/// every frame.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sizes = <String, Size>{
    'desktop': Size(1440, 900),
    'laptop': Size(1024, 768),
    'phone': Size(390, 844),
  };

  final shells = <String, Widget>{
    'Windows': const WindowsDesktop(),
    'macOS': const MacDesktop(),
    'Ubuntu': const LinuxDesktop(),
    'Android': const AndroidLauncher(),
    'iOS': const IosLauncher(),
    'Web': const WebLauncher(),
  };

  for (final shell in shells.entries) {
    for (final size in sizes.entries) {
      testWidgets('${shell.key} lays out without overflow at ${size.key}', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(size.value);
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          RepositoryProvider<GithubService>(
            create: (_) => OfflineGithubService(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      OSModeCubit(detect: () => detectedIs(OSMode.windows)),
                ),
                BlocProvider(create: (_) => NowPlayingCubit(autoStart: false)),
                BlocProvider(create: (_) => WindowManagerCubit()),
                BlocProvider(create: (_) => ThemeCubit()),
                BlocProvider(
                  create: (_) => FileSystemCubit(projectLoader: EmptyLoader()),
                ),
              ],
              child: MaterialApp(home: shell.value),
            ),
          ),
        );
        await tester.pump();

        expect(
          tester.takeException(),
          isNull,
          reason: '${shell.key} overflowed at ${size.key} '
              '(${size.value.width}x${size.value.height})',
        );
      });
    }
  }
}
