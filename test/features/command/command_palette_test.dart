import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio_app/features/command/command_palette.dart';
import 'package:flutter_portfolio_app/features/os_mode/cubit/os_mode_cubit.dart';
import 'package:flutter_portfolio_app/features/os_mode/os_mode.dart';
import 'package:flutter_portfolio_app/features/virtual_window/cubit/window_manager_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late OSModeCubit os;
  late WindowManagerCubit windows;

  setUp(() {
    os = OSModeCubit(detect: () => detectedIs(OSMode.windows));
    windows = WindowManagerCubit();
  });
  tearDown(() async {
    await os.close();
    await windows.close();
  });

  /// Opens the palette the way Ctrl-K does: from the home route, in a dialog
  /// route of its own with no Material above it.
  Future<void> openPalette(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: os),
          BlocProvider.value(value: windows),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: GestureDetector(
                  onTap: () => CommandPalette.show(context),
                  child: const Text('open palette'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open palette'));
    await settle(tester);
  }

  testWidgets('opens with a working search field', (tester) async {
    await openPalette(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Open GitHub profile'), findsOneWidget);
  });

  testWidgets('typing filters the actions', (tester) async {
    await openPalette(tester);

    await tester.enterText(find.byType(TextField), 'linkedin');
    await settle(tester);
    expect(find.text('Open LinkedIn'), findsOneWidget);
    expect(find.text('Open GitHub profile'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzzz-nothing');
    await settle(tester);
    expect(find.text('No matches'), findsOneWidget);
  });

  testWidgets('Escape closes it', (tester) async {
    await openPalette(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await settle(tester);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('tapping outside the panel closes it', (tester) async {
    await openPalette(tester);

    await tester.tapAt(const Offset(4, 4));
    await settle(tester);
    expect(find.byType(TextField), findsNothing);
  });

  group('from the landing page', () {
    testWidgets('Boot enters that OS instead of changing hidden state',
        (tester) async {
      await openPalette(tester);

      await tester.enterText(
        find.byType(TextField),
        'Boot ${OSMode.macos.label}',
      );
      await settle(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await settle(tester);

      expect(os.state.isInOS, isTrue);
      expect(os.state.mode, OSMode.macos);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('Open terminal enters the OS with the terminal waiting',
        (tester) async {
      await openPalette(tester);

      await tester.enterText(find.byType(TextField), 'terminal');
      await settle(tester);
      expect(find.text('Enters the OS'), findsOneWidget);

      await tester.tap(find.text('Open terminal'));
      await settle(tester);

      expect(os.state.isInOS, isTrue);
      expect(windows.state.windows, hasLength(1));
    });

    testWidgets('does not offer to open the page you are already on',
        (tester) async {
      await openPalette(tester);

      await tester.enterText(find.byType(TextField), 'portfolio');
      await settle(tester);
      expect(find.text('Open portfolio'), findsNothing);
    });
  });

  group('inside the OS', () {
    setUp(() {
      os
        ..enterOS(OSMode.windows)
        ..bootComplete();
    });

    testWidgets('Boot switches shells', (tester) async {
      await openPalette(tester);

      await tester.enterText(
        find.byType(TextField),
        'Boot ${OSMode.linux.label}',
      );
      await settle(tester);
      // The search field holds the same text; tap the result row.
      await tester.tap(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Boot ${OSMode.linux.label}'),
        ),
      );
      await settle(tester);

      expect(os.state.mode, OSMode.linux);
      expect(os.state.isInOS, isTrue);
    });

    testWidgets('offers the portfolio window', (tester) async {
      await openPalette(tester);

      await tester.enterText(find.byType(TextField), 'portfolio');
      await settle(tester);
      expect(find.text('Open portfolio'), findsOneWidget);
    });
  });
}

/// The focused search field blinks its cursor forever, so settle with fixed
/// frames rather than pumpAndSettle.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
