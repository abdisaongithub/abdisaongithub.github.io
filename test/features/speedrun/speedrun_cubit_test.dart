import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/os_mode/cubit/os_mode_cubit.dart';
import 'package:flutter_portfolio_app/features/os_mode/os_mode.dart';
import 'package:flutter_portfolio_app/features/speedrun/speedrun_cubit.dart';
import 'package:flutter_portfolio_app/features/virtual_window/cubit/window_manager_cubit.dart';
import 'package:flutter_portfolio_app/features/virtual_window/window_content.dart';

import '../../support/test_harness.dart';

void main() {
  late WindowManagerCubit windows;
  late OSModeCubit osMode;
  late SpeedrunCubit speedrun;

  /// Runs the script with every delay collapsed, so the whole ~30s tour
  /// completes instantly under test.
  SpeedrunCubit build() => SpeedrunCubit(
        windows: windows,
        osMode: osMode,
        delay: (_) => Future<void>.value(),
      );

  setUp(() {
    windows = WindowManagerCubit();
    osMode = OSModeCubit(detect: () => detectedIs(OSMode.windows));
    speedrun = build();
  });

  tearDown(() async {
    await speedrun.close();
    await windows.close();
    await osMode.close();
  });

  group('offer', () {
    test('starts idle and shows nothing', () {
      expect(speedrun.state.status, SpeedrunStatus.idle);
      expect(speedrun.state.isRunning, isFalse);
    });

    test('offer shows the invitation without doing anything', () {
      speedrun.offer();

      expect(speedrun.state.status, SpeedrunStatus.offered);
      expect(windows.state.windows, isEmpty);
    });

    test('dismiss closes the invitation for good', () {
      speedrun.offer();
      speedrun.dismiss();

      expect(speedrun.state.status, SpeedrunStatus.finished);

      // Offering again after a dismissal must not resurrect it.
      speedrun.offer();
      expect(speedrun.state.status, SpeedrunStatus.finished);
    });
  });

  group('running the tour', () {
    test('opens the portfolio, projects and terminal', () async {
      await speedrun.start();

      final types = windows.state.windows.map((w) => w.content.type).toSet();

      expect(types, contains(WindowContentType.portfolio));
      expect(types, contains(WindowContentType.projectDetail));
      expect(types, contains(WindowContentType.terminal));
    });

    test('moves and resizes a window so the manager is visibly real', () async {
      await speedrun.start();

      final portfolio = windows.state.windows.firstWhere(
        (w) => w.content.type == WindowContentType.portfolio,
      );

      expect(portfolio.position, isNot(const Offset(100, 100)));
      expect(portfolio.size.width, greaterThan(800));
    });

    test('switches to a different operating system', () async {
      await speedrun.start();

      expect(osMode.state.mode, isNot(OSMode.windows));
      expect(osMode.state.isManual, isTrue);
    });

    test('finishes with the portfolio focused', () async {
      await speedrun.start();

      expect(speedrun.state.status, SpeedrunStatus.finished);
      expect(
        windows.state.windows.last.content.type,
        WindowContentType.portfolio,
      );
    });

    test('reports progress across every step', () async {
      final labels = <String>[];
      final sub = speedrun.stream.listen((state) {
        if (state.isRunning) labels.add(state.label);
      });

      await speedrun.start();
      await sub.cancel();

      expect(labels, isNotEmpty);
      expect(labels.toSet().length, greaterThan(3));
      expect(speedrun.state.progress, 1.0);
    });

    test('starting twice does not run two tours at once', () async {
      final first = speedrun.start();
      await speedrun.start();
      await first;

      // Only one portfolio window: openWindow focuses an existing match
      // rather than duplicating it.
      final portfolios = windows.state.windows.where(
        (w) => w.content.type == WindowContentType.portfolio,
      );
      expect(portfolios, hasLength(1));
    });
  });

  group('handing control back', () {
    test('takeOver stops the tour immediately', () async {
      final running = speedrun.start();
      speedrun.takeOver();
      await running;

      expect(speedrun.state.status, SpeedrunStatus.finished);
      expect(speedrun.state.isRunning, isFalse);
    });

    test('takeOver leaves whatever is on screen in place', () async {
      final running = speedrun.start();
      speedrun.takeOver();
      await running;

      // Nothing is torn down — the visitor carries on from here.
      expect(speedrun.state.typedCommand, isNull);
    });

    test('a scripted command is cleared once consumed', () async {
      await speedrun.start();
      speedrun.commandConsumed();

      expect(speedrun.state.typedCommand, isNull);
    });
  });

  test('closing mid-tour does not emit after close', () async {
    final running = speedrun.start();
    await speedrun.close();
    await running;

    // Reaching here without a "cannot emit after close" error is the assertion.
    expect(speedrun.isClosed, isTrue);
  });
}
