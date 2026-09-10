import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/apps/widgets/terminal_app.dart';
import 'package:flutter_portfolio_app/features/file_system/cubit/file_system_cubit.dart';
import 'package:flutter_portfolio_app/features/os_mode/cubit/os_mode_cubit.dart';
import 'package:flutter_portfolio_app/features/os_mode/os_mode.dart';
import 'package:flutter_portfolio_app/features/speedrun/speedrun_cubit.dart';
import 'package:flutter_portfolio_app/features/virtual_window/cubit/window_manager_cubit.dart';
import 'package:flutter_portfolio_app/features/virtual_window/window_content.dart';

import '../../support/test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WindowManagerCubit windows;

  Future<String> pumpTerminal(WidgetTester tester) async {
    windows.openWindow(
      const WindowContent(
        type: WindowContentType.terminal,
        title: 'Terminal',
      ),
    );
    final windowId = windows.state.windows.single.id;

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: windows),
          BlocProvider(
            create: (_) => FileSystemCubit(projectLoader: EmptyLoader()),
          ),
          // The terminal listens for scripted commands from the speedrun.
          BlocProvider(
            create: (_) => SpeedrunCubit(
              windows: windows,
              osMode: OSModeCubit(detect: () => detectedIs(OSMode.windows)),
              delay: (_) => Future<void>.value(),
            ),
          ),
        ],
        child:
            MaterialApp(home: Scaffold(body: TerminalApp(windowId: windowId))),
      ),
    );
    await tester.pump();
    return windowId;
  }

  Future<void> run(WidgetTester tester, String command) async {
    await tester.enterText(find.byType(TextField), command);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump();
  }

  setUp(() => windows = WindowManagerCubit());
  tearDown(() => windows.close());

  testWidgets('exit closes the terminal window', (tester) async {
    await pumpTerminal(tester);
    expect(windows.state.windows, hasLength(1));

    await run(tester, 'exit');
    // The close is deferred to a post-frame callback so the window is not
    // disposed mid-build.
    await tester.pumpAndSettle();

    expect(windows.state.windows, isEmpty);
  });

  testWidgets('quit is accepted as an alias', (tester) async {
    await pumpTerminal(tester);

    await run(tester, 'quit');
    await tester.pumpAndSettle();

    expect(windows.state.windows, isEmpty);
  });

  testWidgets('exit only closes its own window', (tester) async {
    await pumpTerminal(tester);
    windows.openWindow(
      const WindowContent(
        type: WindowContentType.settings,
        title: 'Settings',
      ),
    );
    expect(windows.state.windows, hasLength(2));

    await run(tester, 'exit');
    await tester.pumpAndSettle();

    expect(windows.state.windows, hasLength(1));
    expect(
      windows.state.windows.single.content.type,
      WindowContentType.settings,
    );
  });

  testWidgets('help lists exit', (tester) async {
    await pumpTerminal(tester);
    await run(tester, 'help');

    expect(find.textContaining('exit'), findsWidgets);
  });

  testWidgets('an unknown command reports rather than throwing', (
    tester,
  ) async {
    await pumpTerminal(tester);
    await run(tester, 'notacommand');

    expect(find.textContaining('Command not found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // Regression: `open` used to throw out of the command handler via
  // firstWhere(orElse: () => throw ...).
  testWidgets('open on a missing file reports instead of throwing', (
    tester,
  ) async {
    await pumpTerminal(tester);
    await run(tester, 'open nope.md');

    expect(find.textContaining('No such file'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
