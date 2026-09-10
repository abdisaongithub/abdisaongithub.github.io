import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio_app/features/guide/guide_anchor.dart';
import 'package:flutter_portfolio_app/features/guide/guide_cubit.dart';
import 'package:flutter_portfolio_app/features/guide/guide_overlay.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _steps = [
  GuideStep(target: GuideTarget.apps, title: 'Open an app', body: 'Click.'),
  GuideStep(target: GuideTarget.terminal, title: 'Terminal', body: 'Type.'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GuideCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    cubit = GuideCubit();
  });
  tearDown(() => cubit.close());

  Future<void> pumpPage(
    WidgetTester tester, {
    bool withTerminal = true,
    VoidCallback? onApps,
    double scale = 1,
  }) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Positioned(
                  left: 40,
                  top: 40,
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topLeft,
                    child: GuideAnchor(
                      target: GuideTarget.apps,
                      child: ElevatedButton(
                        onPressed: onApps ?? () {},
                        child: const Text('Apps'),
                      ),
                    ),
                  ),
                ),
                if (withTerminal)
                  const Positioned(
                    right: 40,
                    bottom: 40,
                    child: GuideAnchor(
                      target: GuideTarget.terminal,
                      child: SizedBox(width: 40, height: 40),
                    ),
                  ),
                const GuideOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The ring animates forever while open, so settle with fixed frames.
  Future<void> frames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('shows nothing while closed', (tester) async {
    await pumpPage(tester);
    expect(find.textContaining('TIP'), findsNothing);
  });

  testWidgets('walks forward, back and closes', (tester) async {
    await pumpPage(tester);
    cubit.open(_steps);
    await frames(tester);

    expect(find.text('TIP 1 OF 2'), findsOneWidget);
    expect(find.text('Open an app'), findsOneWidget);
    expect(find.text('Back'), findsNothing);

    await tester.tap(find.text('Next'));
    await frames(tester);
    expect(find.text('TIP 2 OF 2'), findsOneWidget);
    expect(find.text('Got it'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await frames(tester);
    expect(find.text('TIP 1 OF 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Close (Esc)'));
    await frames(tester);
    expect(find.textContaining('TIP'), findsNothing);
    expect(cubit.state.isOpen, isFalse);
  });

  testWidgets('never blocks the page — the visitor does the clicking',
      (tester) async {
    var opened = 0;
    await pumpPage(tester, onApps: () => opened++);
    cubit.open(_steps);
    await frames(tester);

    await tester.tap(find.text('Apps'));
    await frames(tester);

    expect(opened, 1);
    // Using the control does not advance or close anything on its own.
    expect(find.text('TIP 1 OF 2'), findsOneWidget);
  });

  testWidgets('skips controls that are not on screen', (tester) async {
    await pumpPage(tester, withTerminal: false);
    cubit.open(GuideAnchors.available(_steps));
    await frames(tester);

    expect(find.text('TIP 1 OF 1'), findsOneWidget);
    expect(find.text('Got it'), findsOneWidget);
  });

  testWidgets('Escape closes the guide', (tester) async {
    await pumpPage(tester);
    cubit.open(_steps);
    await frames(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await frames(tester);
    expect(cubit.state.isOpen, isFalse);
  });

  testWidgets('picks up a guide that was already open', (tester) async {
    cubit.open(_steps);
    await pumpPage(tester);
    await frames(tester);

    expect(find.text('TIP 1 OF 2'), findsOneWidget);
  });

  testWidgets('places the card beside, not over, the highlighted control',
      (tester) async {
    await pumpPage(tester);
    cubit.open(_steps);
    await frames(tester);

    final control = tester.getRect(find.byType(ElevatedButton));
    final card = tester.getRect(find.text('Open an app'));
    expect(card.top, greaterThan(control.bottom));
  });

  testWidgets('measures controls through transforms like the phone frame',
      (tester) async {
    await pumpPage(tester, scale: 0.5);

    final surface = tester.element(find.byType(Scaffold));
    final rect = GuideAnchors.rectOf(GuideTarget.apps, surface)!;
    final onScreen = tester.getRect(find.byType(ElevatedButton));

    expect(rect.left, moreOrLessEquals(onScreen.left));
    expect(rect.top, moreOrLessEquals(onScreen.top));
    expect(rect.width, moreOrLessEquals(onScreen.width));
    expect(rect.height, moreOrLessEquals(onScreen.height));
  });

  testWidgets('an anchor unregisters when it leaves the tree', (tester) async {
    await pumpPage(tester);
    expect(GuideAnchors.isMounted(GuideTarget.terminal), isTrue);

    await pumpPage(tester, withTerminal: false);
    expect(GuideAnchors.isMounted(GuideTarget.terminal), isFalse);
    expect(GuideAnchors.isMounted(GuideTarget.apps), isTrue);
  });
}
